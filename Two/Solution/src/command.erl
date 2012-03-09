-module(command).
-export([parse/1]).
-include("command.hrl").

-spec(parse(string()) -> {error,empty_command}).
parse("") ->
    {error,empty_command};    

parse("list bind") ->
    #binding{type = list}.

