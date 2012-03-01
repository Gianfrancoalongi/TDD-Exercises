-module(ros_parser_tests).
-include_lib("eunit/include/eunit.hrl").
-include("include/ros.hrl").

ros_parse_empty_test() ->
    Input = "",
    ?assertMatch({error,no_data},ros_parser:parse(Input)).

ros_parse_basic_test() ->
    Input = "a,1,1\nb,2,2\n3",
    ?assertMatch({ok,
		  #ros{ entries = [#entry{type = "a",
					  sold = 1,
					  projected = 1},
				   #entry{type = "b",
					  sold = 2,
					  projected = 2}
				   ],
			total = 3}},
		 ros_parser:parse(Input)).

ros_parse_negative_no_total_but_rows_test() ->
    Input = "a,1,1\nb,2,2",
    ?assertMatch({error,no_total},ros_parser:parse(Input)).
    
		    
