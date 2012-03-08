-module(port).
-export([open/3,
	 close/1
	]).
-record(port,{type :: echo,
	      socket :: gen_tcp:socket(),
	      number :: integer()
	     }).

-spec(open(string(),integer(),atom() | string()) -> {ok,gen_tcp:socket()} | {error,no_such_module}).
open(_,Port,echo) ->
    {ok,Sock} = gen_tcp:listen(Port,[{active,false}]),
    {ok,#port{type = echo,
	      socket = Sock,
	      number = Port}};
open(FileDir,Port,ModuleName) ->
    {ok,Files} = file:list_dir(FileDir),
    case lists:member(ModuleName++".erl",Files) of
	false ->
	    {error,no_such_module}
    end.    


-spec(close(#port{}) -> ok).
close(Port) ->
    gen_tcp:close(Port#port.socket).
	
    
