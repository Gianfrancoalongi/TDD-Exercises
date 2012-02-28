-module(ros_tests).
-include_lib("eunit/include/eunit.hrl").

-define(FILE_NAME,"analysis_result_user_acceptance_test.txt").
-define(UAT_DIR,"test/user_acceptance_test/").

user_acceptance_test_() ->
    {setup,
     fun setup/0,
     fun cleanup/1,
     fun uat/0}.

setup() ->
    file:delete(?FILE_NAME).

cleanup(_) ->
    file:delete(?FILE_NAME).

uat() ->
    ?assertEqual(ok, ros:analyze(?UAT_DIR)),
    {ok,UAT_Result_Content} = file:read_file(?UAT_DIR++"user_acceptance_test.txt"),
    {ok,Own_Result_Content} = file:read_file("analysis_result_user_acceptance_test.txt"),
    ?assertEqual(UAT_Result_Content,Own_Result_Content).
    
    
