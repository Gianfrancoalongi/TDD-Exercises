-module(ros).
-export([analyze/1]).

-spec(analyze(string()) -> ok).
analyze(Path) ->
    Base = filename:basename(Path),
    Result = ros_engine:run_dir(Path),
    ToFile = build_result_string(Result),
    File = "analysis_result_"++Base++".txt",
    file:write_file(File,ToFile).

build_result_string(Result) ->
    brs(Result,"PASSED_FILES:\n","FAILED_FILES:\n").

brs([],Good,Bad) -> 
    Good++"\n"++Bad;
brs([{File,ok}|T],Good,Bad) ->
    brs(T,Good++File++"\n",Bad);
brs([{File,{error,Cause}}|T],Good,Bad) ->
    brs(T,Good,Bad++File++","++cause_to_string(Cause)++"\n").

cause_to_string({Cause,Num}) ->
    atom_to_list(Cause)++","++integer_to_list(Num).



	
    
    
    
		      
    
