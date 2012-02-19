-module(ros_analyzer_tests).
-include_lib("eunit/include/eunit.hrl").
-include("include/ros.hrl").

analysis_underflow_discrepancy_test() ->
    Entries = [#entry{type = "a",
		      sold = 1,
		      projected = 10}],
    Analysis_input = #ros{entries = Entries,
			  total = 11},
    ?assertEqual({error,{underflow,-1}},ros_analyzer:analyze(Analysis_input)).

analysis_overflow_discrepancy_test() ->
    Entries = [#entry{type = "a",
		      sold = 1,
		      projected = 10}],
    Analysis_input = #ros{entries = Entries,
			  total = 9},
    ?assertEqual({error,{overflow,1}},ros_analyzer:analyze(Analysis_input)).
    

    
