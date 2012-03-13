-module(server).
-include("command.hrl").
-include("port.hrl").
-export([start/1,
	 stop/1]).

-record(state,{bindings = [] :: [{string(),string()}],
	       ports = [] :: [{atom(),non_neg_integer(),pid()}],
	       command_port :: non_neg_integer(),
	       files_dir :: string()
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
    loop(Sock,#state{command_port = CommandPort,
		     files_dir = FilesDir
		    }).

loop(Sock,ServerState) ->
    {ok,Session} = gen_tcp:accept(Sock),
    case gen_tcp:recv(Session,0) of
	{error,closed} ->
	    gen_tcp:close(Session),
	    loop(Sock,ServerState);
	{ok,"stop"} ->
	    gen_tcp:send(Session,"stopping"),
	    gen_tcp:close(Session),
	    gen_tcp:close(Sock);
	{ok,Command} ->
	    Res = command:parse(Command),
	    {Reply,NewServerState} = perform_command(Res,ServerState),
	    gen_tcp:send(Session,Reply),
	    loop(Sock,NewServerState)
    end.

perform_command(#binding_command{type = list},#state{bindings = []} = State) ->
    {"bindings: none",State};

perform_command(#binding_command{type = list},#state{bindings = Bindings} = State) ->
    {lists:foldl(
       fun({Type,File},Res) -> Res++"\n "++Type++", "++File
       end,
       "bindings:",
       Bindings),State};

perform_command(#binding_command{type = bind,arguments = Args},State) ->
    [Type,File] = pick([type,file],Args),
    Bindings = State#state.bindings,
    {"binding created",State#state{bindings = [{Type,File}|Bindings]}};

perform_command(#binding_command{type = unbind,arguments = Args},State) ->
    Type = proplists:get_value(type,Args),
    Bindings = [{T,F} || {T,F} <- State#state.bindings,T =/= Type],
    {"binding undone",State#state{bindings = Bindings}};

perform_command(#port_command{type = list},State) ->
    Last = "\n command-port, "++integer_to_list(State#state.command_port),
    {lists:foldl(
       fun({Type,Port,_Pid},Acc) -> 
	       Acc ++ "\n "++Type++", "++integer_to_list(Port)
       end,
       "ports:",
       State#state.ports)++Last,State};

perform_command(#port_command{type = open,arguments = Args}, State) ->
    [Port,Type] = pick([port,type],Args),
    #state{bindings = Bindings, files_dir = Dir, ports = Ports} = State,
    File = proplists:get_value(Type,Bindings),
    Pid = spawn_link(fun() ->
			     {ok,PortRecord} = port:open(Dir,Port,File),
			     port_loop(PortRecord)
		     end),
    {"port opened",State#state{ports = [{Type,Port,Pid}|Ports]}}.

port_loop(#port{socket = Sock} = Port) ->
    {ok,Active} = gen_tcp:accept(Sock),
    spawn_link(fun() ->
		       {ok,Got} = gen_tcp:recv(Active,0),
		       gen_tcp:send(Active,port:handle(Port,Got)),
		       gen_tcp:close(Active)
	       end),
    port_loop(Port).


pick(What,From) ->
    pick_aux(What,From,[]).

pick_aux([],_,Res) ->
    lists:reverse(Res);
pick_aux([P|T],From,Res) ->
    pick_aux(T,From,[proplists:get_value(P,From)|Res]).

		  
    



