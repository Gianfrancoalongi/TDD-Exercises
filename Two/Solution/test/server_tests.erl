-module(server_tests).
-include_lib("eunit/include/eunit.hrl").
-define(COMMAND_PORT,50001).

server_start_test() ->
    CommandPort = 50001,
    Options = [{files,"./test/test_files/"},
	       {command_port,CommandPort}],
    ?assertMatch(ok,server:start(Options)),
    assert_port_open(CommandPort),
    ?assertEqual(ok,server:stop(CommandPort)),
    assert_port_closed(CommandPort).

command_test_() ->
    {foreach,
     fun start/0,
     fun stop/1,
     [fun list_bind/0,
      fun bind_type/0,
      fun unbind_type/0,
      fun list_port/0,
      fun open_port/0
      ]}.

list_bind() ->
    ?assertEqual("bindings: none",send_receive_command("list bind")).

bind_type() ->
    ?assertEqual("binding created",
		 send_receive_command("bind testtype compilation_clean_module")),
    ?assertEqual("bindings:\n"
		 " testtype, compilation_clean_module",
		 send_receive_command("list bind")).

unbind_type() ->
    send_receive_command("bind testtype compilation_clean_module"),
    ?assertEqual("binding undone",send_receive_command("unbind testtype")),
    ?assertEqual("bindings: none",send_receive_command("list bind")).
    
list_port() ->
    ?assertEqual("ports:\n"
		 " command-port, 50001",
		 send_receive_command("list port")).

open_port() ->
    ?assertEqual("binding created",send_receive_command("bind ab echo")),
    ?assertEqual("port opened",send_receive_command("open 50002 ab")),
    ?assertEqual("ports:\n"
		 " ab, 50002\n"
		 " command-port, 50001",
		 send_receive_command("list port")).
    
    
%% --------------------------------------------------
start() ->
    Options = [{files,"./test/test_files/"},
	       {command_port,?COMMAND_PORT}],
    server:start(Options),
    ok.

stop(ok) ->
    server:stop(?COMMAND_PORT).
    
assert_port_open(Port) ->
    {ok,Sock} = gen_tcp:connect("localhost",Port,[]),
    gen_tcp:close(Sock).

assert_port_closed(Port) ->
    {error,econnrefused} = gen_tcp:connect("localhost",Port,[]).

send_receive_command(Command) ->
    {ok,Sock} = gen_tcp:connect("localhost",?COMMAND_PORT,[{active,false}]),
    gen_tcp:send(Sock,Command),
    {ok,Socket} = gen_tcp:recv(Sock,0),
    Socket.
