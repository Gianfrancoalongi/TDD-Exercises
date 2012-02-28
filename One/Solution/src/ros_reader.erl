-module(ros_reader).
-export([read_file/1,
	 read_dir/1
	]).

-spec(read_file(string()) -> binary() | {error,no_such_file}).
read_file(File) ->
    case file:read_file(File) of
	{error,enoent} ->
	    {error,no_such_file};
	{ok,R} -> R
    end.

-spec(read_dir(string()) -> {ok,[{string(),term()}]} | {error,no_such_dir}).
read_dir(Dir) ->
    case file:list_dir(Dir) of
	{ok,Files} ->	    
	    OnlyRos = [ File || File <- Files, filename:extension(File) == ".ros"],
	    Res = [{File, read_file(filename:join(Dir,File))} || File <- OnlyRos ],
	    {ok,lists:sort(Res)};
	{error,enoent} ->
	    {error,no_such_dir}
    end.

