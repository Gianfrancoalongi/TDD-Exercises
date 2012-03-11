-module(server).
-include("command.hrl").
-export([start/1,
	 stop/1]).

-record(state,{bindings = [] :: [{string(),string()}]
	      }).

-spec(start([{atom(),string() | integer()}]) -> ok).
start(Options) ->
    FilesDir = proplists:get_value(files,Options),
    CommandPort = proplists:get_value(command_port,Options),
    Ref = make_ref(),
    Synchronizer = {self(),Ref},
    Pid = spawn_link(fun() -> start(Synchronizer,FilesDir,CommandPort) end),
    receive
	{started,Pid,Ref} -> ok
    end.

-spec(stop(non_neg_integer()) -> ok).
stop(CommandPort) ->
    {ok,Sock} = gen_tcp:connect("localhost",CommandPort,[{active,false}]),
    gen_tcp:send(Sock,"stop"),
    {ok,"stopping"} = gen_tcp:recv(Sock,0),
    ok.

start({To,Ref},FilesDir,CommandPort) ->
    {ok,Sock} = gen_tcp:listen(CommandPort,[{active,false},{reuseaddr,true}]),
    register(server,self()),
    To ! {started,self(),Ref},
    loop(FilesDir,Sock,#state{}).

loop(_FilesDir,Sock,ServerState) ->
    {ok,Session} = gen_tcp:accept(Sock),
    case gen_tcp:recv(Session,0) of
	{error,closed} ->
	    gen_tcp:close(Session),
	    loop(_FilesDir,Sock,ServerState);
	{ok,"stop"} ->
	    gen_tcp:send(Session,"stopping"),
	    gen_tcp:close(Session),
	    gen_tcp:close(Sock);
	{ok,Command} ->
	    Res = command:parse(Command),
	    {Reply,NewServerState} = perform_command(Res,ServerState),
	    gen_tcp:send(Session,Reply),
	    loop(_FilesDir,Sock,NewServerState)
    end.

perform_command(#binding{type = list},#state{bindings = []} = State) ->
    {"bindings: none",State};
perform_command(#binding{type = list},#state{bindings = Bindings} = State) ->
    {lists:foldl(
       fun({Type,File},Res) -> Res++"\n "++Type++", "++File
       end,
       "bindings:",
       Bindings),State};
perform_command(#binding{type = bind,arguments = Args},State) ->
    Type = proplists:get_value(type,Args),
    File = proplists:get_value(file,Args),
    Bindings = State#state.bindings,
    {"binding created",State#state{bindings = [{Type,File}|Bindings]}};
perform_command(#binding{type = unbind,arguments = Args},State) ->
    Type = proplists:get_value(type,Args),
    Bindings = [{T,F} || {T,F} <- State#state.bindings,T =/= Type],
    {"binding undone",State#state{bindings = Bindings}}.

