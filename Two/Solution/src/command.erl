-module(command).
-export([parse/1]).
-include("command.hrl").

-spec(parse(string()) -> {error,empty_command} | #binding{}).
parse("") ->
    {error,empty_command};    

parse("list bind") ->
    #binding{type = list};

parse("bind "++Rest) ->
    [Type,File] = string:tokens(Rest," "),
    #binding{type = bind,
	     arguments = [{type,Type},
			  {file,File}]}.
    
	    

