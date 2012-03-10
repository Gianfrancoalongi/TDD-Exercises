-module(server).
-export([start/1,
	 stop/0]).

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

-spec(stop() -> ok).
stop() ->
    Pid = self(),
    Ref = make_ref(),
    server ! {stop,Pid,Ref},
    receive
	{stopped,Ref} ->
	    ok
    end.
	

start({To,Ref},FilesDir,CommandPort) ->
    {ok,Sock} = gen_tcp:listen(CommandPort,[{active,false}]),
    register(server,self()),
    To ! {started,self(),Ref},
    loop(FilesDir,Sock).

loop(_FilesDir,Sock) ->
    receive
	{stop,From,Ref} ->
	    gen_tcp:close(Sock),
	    unregister(server),
	    From ! {stopped,Ref}
    end.
