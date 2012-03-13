-module(command).
-export([parse/1]).
-include("command.hrl").

-spec(parse(string()) -> {error,empty_command} | #binding_command{} | #port_command{}).
parse("") ->
    {error,empty_command};    

parse("list bind") ->
    #binding_command{type = list};

parse("bind "++Rest) ->
    [Type,ParseFile] = string:tokens(Rest," "),
    File = case ParseFile of
	       "echo" -> echo;
	       _ -> ParseFile
	   end,
    #binding_command{type = bind,
		     arguments = [{type,Type},
				  {file,File}]};

parse("unbind "++Type) ->
    #binding_command{type = unbind,
		     arguments = [{type,Type}]};

parse("open "++Rest) ->
    [Port,Type] = string:tokens(Rest," "),
    #port_command{type = open,
		  arguments = [{port,list_to_integer(Port)},
			       {type,Type}]};

parse("close "++Rest) ->
    #port_command{type = close,
		  arguments = [{port,list_to_integer(Rest)}]};

parse("list port") ->
    #port_command{type = list}.




    
	    


