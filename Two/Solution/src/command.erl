-module(command).
-export([parse/1]).

-spec(parse(string()) -> {error,empty_command}).
parse("") ->
    {error,empty_command}.    
