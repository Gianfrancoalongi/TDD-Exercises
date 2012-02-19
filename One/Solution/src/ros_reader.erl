-module(ros_reader).
-export([read_file/1]).

-spec(read_file(string()) -> {ok,term()}).
read_file(File) ->
    case file:read_file(File) of
	{error,enoent} ->
	    {error,no_such_file};
	R -> R
    end.

