-module(server).
-export([start/1,
	 stop/1]).

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
    {ok,Sock} = gen_tcp:listen(CommandPort,[{active,false}]),
    register(server,self()),
    To ! {started,self(),Ref},
    loop(FilesDir,Sock).

loop(_FilesDir,Sock) ->
    {ok,Session} = gen_tcp:accept(Sock),
    case gen_tcp:recv(Session,0) of
	{ok,"stop"} ->
	    gen_tcp:send(Session,"stopping"),
	    gen_tcp:close(Session),
	    gen_tcp:close(Sock);
	{error,closed} ->
	    gen_tcp:close(Session),
	    loop(_FilesDir,Sock)
    end.
