-module(ros_parser).
-export([parse/1]).

-spec(parse(string()) -> {error,no_total}).
parse("")-> {error,no_total}.
    
    
