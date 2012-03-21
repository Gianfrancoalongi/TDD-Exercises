-module(pubsub_pipes_tests).
-include_lib("eunit/include/eunit.hrl").

pipe_test_() ->
    {foreach,
     fun setup/0,
     fun cleanup/1,
     [
      fun create_pipe/0,
      fun register_on_pipe/0
      ]}.

setup() ->
    pubsub_pipes:start_link().

cleanup(_) ->
    pubsub_pipes:stop().

    
create_pipe() ->
    PipeName = "A",
    ok = pubsub_pipes:new_pipe(PipeName),
    ?assertEqual([PipeName],pubsub_pipes:get_pipes()).

register_on_pipe() ->
    PipeName = "A",
    Self = self(),
    ok = pubsub_pipes:new_pipe(PipeName),
    ok = pubsub_pipes:subscribe_to_pipe(PipeName),    
    ?assertEqual([Self],pubsub_pipes:get_subscribers_to_pipe(PipeName)).
		       
    
