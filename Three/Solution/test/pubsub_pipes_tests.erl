-module(pubsub_pipes_tests).
-include_lib("eunit/include/eunit.hrl").

create_pipe_test() ->
    {setup,
     fun setup/0,
     fun cleanup/1,
     fun() ->
	     PipeName = "A",
	     {ok,_} = pubsub_pipes:new_pipe(PipeName),
	     ?assertEqual([PipeName],pubsub_pipes:get_pipes())
     end}.

setup() ->
    pubsub_pipes:start_link().

cleanup(_) ->
    pubsub_pipes:stop().

    
