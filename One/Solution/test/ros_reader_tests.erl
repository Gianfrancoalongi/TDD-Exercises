-module(ros_reader_tests).
-include_lib("eunit/include/eunit.hrl").

ros_reads_file_test() ->
    File = "./test/january-good-2011.ros",
    ?assertMatch({ok,Result},ros_reader:read_file(File)).

ros_read_bad_file_test() ->
    File = "./test/nonexistent.ros",
    ?assertMatch({error,no_such_file},ros_reader:read_file(File)).

ros_read_dir_test() ->
    Dir = "./test/ros_files/",
    ?assertMatch({ok,
		  [{"file_a.ros",ResultA},
		   {"file_b.ros",ResultB}]},
		 ros_reader:read_dir(Dir)).
    
    
