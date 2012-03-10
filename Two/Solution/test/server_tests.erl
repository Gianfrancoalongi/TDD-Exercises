-module(server_tests).
-include_lib("eunit/include/eunit.hrl").


server_start_test() ->
    CommandPort = 50001,
    Options = [{files,"./test/test_files/"},
	       {command_port,CommandPort}],
    ?assertMatch(ok,server:start(Options)),
    assert_port_open(CommandPort),
    ?assertEqual(ok,server:stop()),
    assert_port_closed(CommandPort).
    

%% --------------------------------------------------
assert_port_open(Port) ->
    {ok,Sock} = gen_tcp:connect("localhost",Port,[]),
    gen_tcp:close(Sock).

assert_port_closed(Port) ->
    {error,econnrefused} = gen_tcp:connect("localhost",Port,[]).
