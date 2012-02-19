-module(ros_parser).
-export([parse/1]).
-include("include/ros.hrl").

-spec(parse(string()) -> {error,no_total} | {ok,#ros{}}).
parse("")-> {error,no_total};

parse(Input) -> 
    [Total|Lines] = lists:reverse(string:tokens(Input,"\n")),    
    Entries = lists:sort([ parse_row(Line) || Line <- Lines]),
    {ok,#ros{total = list_to_integer(Total),
	     entries = Entries}}.

parse_row(Line) ->
    [Type,Sold,Projected] = string:tokens(Line,","),
    #entry{type = Type,
	  sold = list_to_integer(Sold),
	  projected = list_to_integer(Projected)}.
    
    
    
