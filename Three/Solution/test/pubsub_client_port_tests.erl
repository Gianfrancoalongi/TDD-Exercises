-module(pubsub_client_port_tests).
-include_lib("eunit/include/eunit.hrl").

just_started_test() ->
    {ok,First} = pubsub_client_port:start_link(),
    {ok,Second} = pubsub_client_port:start_link(),
    ?assertEqual(none,pubsub_client_port:get_type(First)),
    ?assertEqual(none,pubsub_client_port:get_type(Second)).
    

    
    
