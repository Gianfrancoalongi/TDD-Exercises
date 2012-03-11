-module(server_tests).
-include_lib("eunit/include/eunit.hrl").


server_start_test() ->
    CommandPort = 50001,
    Options = [{files,"./test/test_files/"},
	       {command_port,CommandPort}],
    ?assertMatch(ok,server:start(Options)),
    assert_port_open(CommandPort),
    ?assertEqual(ok,server:stop(CommandPort)),
    assert_port_closed(CommandPort).

server_list_bind_command_test() ->
    CommandPort = 50001,
    Options = [{files,"./test/test_files/"},
	       {command_port,CommandPort}],
    server:start(Options),
    ?assertEqual("bindings: none",send_receive_command(CommandPort,"list bind")),
    server:stop(CommandPort).
    
    
%% --------------------------------------------------
assert_port_open(Port) ->
    {ok,Sock} = gen_tcp:connect("localhost",Port,[]),
    gen_tcp:close(Sock).

assert_port_closed(Port) ->
    {error,econnrefused} = gen_tcp:connect("localhost",Port,[]).

send_receive_command(CommandPort,Command) ->
    {ok,Sock} = gen_tcp:connect("localhost",CommandPort,[{active,false}]),
    gen_tcp:send(Sock,Command),
    {ok,Socket} = gen_tcp:recv(Sock,0),
    Socket.
