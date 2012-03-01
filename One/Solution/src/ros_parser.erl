-module(ros_parser).
-export([parse/1]).
-include("include/ros.hrl").

-spec(parse(string()) -> {error,no_data} | {ok,#ros{}}).
parse("")-> {error,no_data};

parse(Input) -> 
    [Total|Lines] = lists:reverse(string:tokens(Input,"\n")),
    case (catch list_to_integer(Total)) of
	{'EXIT',_ } ->
	    {error,no_total};
	IntTotal ->
	    Entries = lists:sort([ parse_row(Line) || Line <- Lines]),
	    {ok,#ros{total = IntTotal,
		     entries = Entries}}
    end.

parse_row(Line) ->
    [Type,Sold,Projected] = string:tokens(Line,","),
    #entry{type = Type,
	   sold = list_to_integer(Sold),
	   projected = list_to_integer(Projected)}.
    
    
    
