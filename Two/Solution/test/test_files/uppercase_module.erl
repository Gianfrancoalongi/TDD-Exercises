-module(uppercase_module).
-export([handle/1]).
handle(X) ->
    string:to_upper(X).
