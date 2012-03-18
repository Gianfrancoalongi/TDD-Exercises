-module(server).
-include("command.hrl").
-include("port.hrl").
-export([start/1,
	 stop/1]).

-record(state,{bindings = [] :: [{string(),string()}],
	       ports = [] :: [{atom(),#port{},pid()}],
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
	    gen_tcp:close(Sock),
	    Ports = ServerState#state.ports,
	    lists:foreach(
	      fun({_,#port{socket = PortSocket},_}) -> gen_tcp:close(PortSocket)
	      end,Ports);
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
	       Acc ++ "\n "++Type++", "++integer_to_list(Port#port.number)
       end,
       "ports:",
       State#state.ports)++Last,State};

perform_command(#port_command{type = open,arguments = Args}, State) ->
    [Port,Type] = pick([port,type],Args),
    #state{bindings = Bindings, files_dir = Dir, ports = Ports} = State,
    File = proplists:get_value(Type,Bindings),
    Ref = make_ref(),
    Self = self(),
    Pid = spawn_link(fun() ->
			     {ok,PortRecord} = port:open(Dir,Port,File),
			     Self ! {opened,Ref,self(),PortRecord},
			     port_loop(PortRecord)
		     end),
    receive
	{opened,Ref,Pid,PortRecord} -> ok
    end,
    {"port opened",State#state{ports = [{Type,PortRecord,Pid}|Ports]}};

perform_command(#port_command{type = close,arguments = Args}, State) ->
    [Port] = pick([port],Args),
    Ports = close_and_remove_selected_port(Port,State#state.ports),
    {"port closed",State#state{ports = Ports}}.

port_loop(#port{socket = Sock} = Port) ->
    case gen_tcp:accept(Sock) of
	{error,closed} ->
	    ok;
	{ok,Active} ->
	    spawn_link(fun() ->
			       {ok,Got} = gen_tcp:recv(Active,0),		       
			       gen_tcp:send(Active,port:handle(Port,Got)),
			       gen_tcp:close(Active)
		       end),
	    port_loop(Port)
    end.


pick(What,From) ->
    pick_aux(What,From,[]).

pick_aux([],_,Res) ->
    lists:reverse(Res);
pick_aux([P|T],From,Res) ->
    pick_aux(T,From,[proplists:get_value(P,From)|Res]).

close_and_remove_selected_port(PortNumber,[{_,#port{number = PortNumber, 
						    socket = Sock},_} | Ports]) ->
    gen_tcp:close(Sock),
    Ports;
close_and_remove_selected_port(PortNumber,[X|Ports]) ->
    [X|close_and_remove_selected_port(PortNumber,Ports)];
close_and_remove_selected_port(_,[]) -> [].


    



