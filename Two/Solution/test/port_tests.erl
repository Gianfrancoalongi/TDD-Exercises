-module(port_tests).
-include_lib("eunit/include/eunit.hrl").

echo_port_open_close_test() ->
    Port = 50001,
    Type = echo,
    {ok,Openport} =  port:open(Port,Type),
    assert_port_open(Port),
    port:close(Openport),
    assert_port_closed(Port).

%% ------------------------------------------------------------
assert_port_open(Port) ->
    {ok,Sock} = gen_tcp:connect("localhost",Port,[]),
    gen_tcp:close(Sock).

assert_port_closed(Port) ->
    {error,econnrefused} = gen_tcp:connect("localhost",Port,[]).
    
    
    
    
    
    
