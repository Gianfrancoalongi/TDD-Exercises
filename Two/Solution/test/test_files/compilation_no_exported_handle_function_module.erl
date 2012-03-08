-module(compilation_no_exported_handle_function_module).
-export([not_handle/1]).
not_handle(X) ->
    X.
