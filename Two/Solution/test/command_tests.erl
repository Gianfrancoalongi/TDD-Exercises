-module(command_tests).
-include_lib("eunit/include/eunit.hrl").
-include("command.hrl").

empty_command_test() ->
    Command = "",
    ?assertEqual({error,empty_command},command:parse(Command)).

list_bindings_test() ->
    Command = "list bind",
    ?assertMatch(#binding_command{type = list},command:parse(Command)).

bind_test() ->
    Command = "bind testtype testfile.erl",
    ?assertMatch(#binding_command{type = bind,
				  arguments = [{type,"testtype"},
					       {file,"testfile.erl"}]},
		 command:parse(Command)).

unbind_test() ->
    Command = "unbind testtype",
    ?assertMatch(#binding_command{type = unbind,
				  arguments = [{type,"testtype"}]},
		 command:parse(Command)).

open_test() ->
    Command = "open 1234 testtype",
    ?assertMatch(#port_command{type = open,
			       arguments = [{port,1234},
					    {type,"testtype"}]},
		 command:parse(Command)).


close_test() ->		       
    Command = "close 1234",
    ?assertMatch(#port_command{type = close,
			       arguments = [{port,1234}]},
		 command:parse(Command)).

list_port_test() ->
    Command = "list port",
    ?assertMatch(#port_command{type = list},
		 command:parse(Command)).
    
    
