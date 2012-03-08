-module(compilation_error_module).
-export([handle/1]).
handle(_) ->
    Unboundvariable.
