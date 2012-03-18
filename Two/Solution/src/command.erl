-module(command).
-export([parse/1]).
-include("command.hrl").

-spec(parse(string()) -> {error,empty_command} | #binding_command{} | #port_command{}).
parse(Input) ->
    Sanitized = re:replace(Input,"\r|\n","",[{return,list},global]),
    parse_sanitized(Sanitized).

parse_sanitized("") ->
    {error,empty_command};    

parse_sanitized("list bind") ->
    #binding_command{type = list};

parse_sanitized("bind "++Rest) ->
    [Type,ParseFile] = string:tokens(Rest," "),
    File = case ParseFile of
	       "echo" -> echo;
	       _ -> ParseFile
	   end,
    #binding_command{type = bind,
		     arguments = [{type,Type},
				  {file,File}]};

parse_sanitized("unbind "++Type) ->
    #binding_command{type = unbind,
		     arguments = [{type,Type}]};

parse_sanitized("open "++Rest) ->
    [Port,Type] = string:tokens(Rest," "),
    #port_command{type = open,
		  arguments = [{port,list_to_integer(Port)},
			       {type,Type}]};

parse_sanitized("close "++Rest) ->
    #port_command{type = close,
		  arguments = [{port,list_to_integer(Rest)}]};

parse_sanitized("list port") ->
    #port_command{type = list}.




    
	    


