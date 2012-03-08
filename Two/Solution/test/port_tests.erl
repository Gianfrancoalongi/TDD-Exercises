-module(port_tests).
-include_lib("eunit/include/eunit.hrl").

echo_port_open_close_test() ->
    Port = 50001,
    Type = echo,
    FileDir = "./test/test_files/",
    {ok,Openport} =  port:open(FileDir,Port,Type),
    assert_port_open(Port),
    port:close(Openport),
    assert_port_closed(Port).

module_does_not_exist_port_failure_test() ->
    Port = 50001,
    Type = "non_existent_module",
    FileDir = "./test/test_files/",
    ?assertEqual({error,no_such_module},port:open(FileDir,Port,Type)).

module_does_exist_but_can_not_compile_test() ->
    Port = 50001,
    Type = "compilation_error_module",
    FileDir = "./test/test_files/",
    ?assertMatch({error,compile_error},port:open(FileDir,Port,Type)).

    

%% ------------------------------------------------------------
assert_port_open(Port) ->
    {ok,Sock} = gen_tcp:connect("localhost",Port,[]),
    gen_tcp:close(Sock).

assert_port_closed(Port) ->
    {error,econnrefused} = gen_tcp:connect("localhost",Port,[]).
    
    
    
    
    
    
