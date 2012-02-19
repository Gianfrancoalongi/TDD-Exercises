-module(ros_parser_tests).
-include_lib("eunit/include/eunit.hrl").

ros_parse_empty_test() ->
    Input = "",
    ?assertMatch({error,no_total},ros_parser:parse(Input)).
