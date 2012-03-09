-module(command_tests).
-include_lib("eunit/include/eunit.hrl").

empty_command_test() ->
    Command = "",
    ?assertEqual({error,empty_command},command:parse(Command)).
    
