-module(ros_analyzer).
-include("include/ros.hrl").
-export([analyze/1]).

-spec(analyze(#ros{}) -> {error,{total_grater_than_projected | total_less_than_projected,integer()}} | ok).
analyze(#ros{total = Total,entries = Entries}) ->
    Entries_Total = sum_entries(Entries),
    case Entries_Total - Total of
	X when X < 0 ->
	    {error,{total_greater_than_projected,-X}};
	X when X > 0 ->
	    {error,{total_less_than_projected,X}};
	0 ->
	    ok
    end.

sum_entries([]) -> 0;
sum_entries([#entry{projected = Projected}|T]) ->
    Projected + sum_entries(T).
    
	    
    
    
