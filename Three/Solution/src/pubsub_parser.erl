-module(pubsub_parser).
-export([parse/1]).
-include("message.hrl").

-spec(parse(string()) -> #pipe_declaration{}).
parse("publish-connection") ->
    #pipe_declaration{type = publish};
parse("subscribe-connection") ->
    #pipe_declaration{type = subscribe};
parse("ack "++ID) ->
    #message_ack{id = ID}.


