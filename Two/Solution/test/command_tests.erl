-module(command_tests).
-include_lib("eunit/include/eunit.hrl").
-include("command.hrl").

empty_command_test() ->
    Command = "",
    ?assertEqual({error,empty_command},command:parse(Command)).

list_bindings_test() ->
    Command = "list bind",
    ?assertMatch(#binding{type = list},command:parse(Command)).
    
