-module(ros_reader).
-export([read_file/1]).

-spec(read_file(string()) -> {ok,term()}).
read_file(File) ->
    file:read_file(File).

