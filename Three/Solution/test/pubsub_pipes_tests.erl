-module(pubsub_pipes_tests).
-include_lib("eunit/include/eunit.hrl").
-include("../src/message.hrl").

pipe_test_() ->
    {foreach,
     fun setup/0,
     fun cleanup/1,
      [
       {inorder,[
		 fun create_pipe/0,
		 fun register_on_pipe/0,
		 fun deregister_from_pipe/0,
		 fun publish_message_on_pipe/0
		]}
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

deregister_from_pipe() ->
    PipeName = "A",
    ok = pubsub_pipes:new_pipe(PipeName),
    ok = pubsub_pipes:subscribe_to_pipe(PipeName),    
    ok = pubsub_pipes:unsubscribe_from_pipe(PipeName),
    ?assertEqual([],pubsub_pipes:get_subscribers_to_pipe(PipeName)).

publish_message_on_pipe() ->
    PipeName = "A",
    Message = <<1,2,3,4,5>>,
    ok = pubsub_pipes:new_pipe(PipeName),
    ok = pubsub_pipes:subscribe_to_pipe(PipeName),
    ok = pubsub_pipes:publish_message_on_pipe(PipeName,Message),
    Received = receive X -> X end,
    ?assertMatch(
       #message{pipe = PipeName,
		body = Message,
		byte_size = 5},
       Received).
    
    
		       
    
