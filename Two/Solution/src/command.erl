-module(command).
-export([parse/1]).
-include("command.hrl").

-spec(parse(string()) -> {error,empty_command} | #binding{} | #port{}).
parse("") ->
    {error,empty_command};    

parse("list bind") ->
    #binding{type = list};

parse("bind "++Rest) ->
    [Type,File] = string:tokens(Rest," "),
    #binding{type = bind,
	     arguments = [{type,Type},
			  {file,File}]};

parse("unbind "++Type) ->
    #binding{type = unbind,
	     arguments = [{type,Type}]};

parse("open "++Rest) ->
    [Port,Type] = string:tokens(Rest," "),
    #port{type = open,
	  arguments = [{port,list_to_integer(Port)},
		       {type,Type}]};

parse("close "++Rest) ->
    #port{type = close,
	  arguments = [{port,list_to_integer(Rest)}]};

parse("list port") ->
    #port{type = list}.




    
	    


