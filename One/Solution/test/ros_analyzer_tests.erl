-module(ros_analyzer_tests).
-include_lib("eunit/include/eunit.hrl").
-include("include/ros.hrl").

analysis_underflow_discrepancy_test() ->
    Entries = [#entry{type = "a",
		      sold = 1,
		      projected = 10}],
    Analysis_input = #ros{entries = Entries,
			  total = 11},
    ?assertEqual({error,{total_greater_than_projected,1}},ros_analyzer:analyze(Analysis_input)).

analysis_overflow_discrepancy_test() ->
    Entries = [#entry{type = "a",
		      sold = 1,
		      projected = 10}],
    Analysis_input = #ros{entries = Entries,
			  total = 9},
    ?assertEqual({error,{total_less_than_projected,1}},ros_analyzer:analyze(Analysis_input)).

analysis_ok_test() ->
    Entries = [#entry{type = "a",
		      sold = 1,
		      projected = 10}],
    Analysis_input = #ros{entries = Entries,
			  total = 10},
    ?assertEqual(ok,ros_analyzer:analyze(Analysis_input)).

    

    
