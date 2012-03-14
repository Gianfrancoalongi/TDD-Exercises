-module(reverse_module).
-export([handle/1]).
handle(S) ->
    lists:reverse(S).
