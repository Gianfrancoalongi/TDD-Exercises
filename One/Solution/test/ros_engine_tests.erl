-module(ros_engine_tests).
-include_lib("eunit/include/eunit.hrl").

ros_engine_ok_test() ->
    Dir = "../ROS_files/",
    Res = ros_engine:run_dir(Dir),
    ?assertEqual(
    [{"february-north_branch-2011.ros",ok},
     {"february-south_branch-2011.ros",ok},
     {"january-north_branch-2011.ros",ok},
     {"january-south_branch-2011.ros",ok}],Res).

ros_engine_negative_test() ->
    Dir = "test/ros_files/",
    Res = ros_engine:run_dir(Dir),
    ?assertEqual(
    [{"file_a.ros",{error,no_data}},
     {"file_b.ros",{error,no_data}}],Res).
    
