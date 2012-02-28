-module(ros_engine).
-export([run_dir/1]).

-spec(run_dir(string()) -> [{string(),ok | {error,term()}}]).
run_dir(Dir) ->
    case ros_reader:read_dir(Dir) of
	{ok,Files_Content} ->
	    work_on_files(Files_Content)
    end.
    
work_on_files([]) -> [];
work_on_files([{File,Contains}|Rest]) ->
    case ros_parser:parse(binary_to_list(Contains)) of
	{ok,Ros} ->
	    [{File,ros_analyzer:analyze(Ros)} | work_on_files(Rest)];
	{error,_} = Err ->
	    [{File,Err} | work_on_files(Rest)]
    end.
