-module(pubsub_client_port_tests).
-include_lib("eunit/include/eunit.hrl").

just_started_test() ->
    {ok,First} = pubsub_client_port:start_link(),
    {ok,Second} = pubsub_client_port:start_link(),
    ?assertEqual(none,pubsub_client_port:get_type(First)),
    ?assertEqual(none,pubsub_client_port:get_type(Second)).

announced_intent_for_connection_test() ->
    {ok,First} = pubsub_client_port:start_link(),
    {ok,Second} = pubsub_client_port:start_link(),
    PublishDefinitionMsg = pubsub_parser:parse("publish-connection"),
    SubscribeDefinitionMsg = pubsub_parser:parse("subscribe-connection"),    
    pubsub_client_port:handle_msg(First,PublishDefinitionMsg),
    pubsub_client_port:handle_msg(Second,SubscribeDefinitionMsg),
    ?assertEqual(publish,pubsub_client_port:get_type(First)),
    ?assertEqual(subscribe,pubsub_client_port:get_type(Second)).
    
    

    
    
