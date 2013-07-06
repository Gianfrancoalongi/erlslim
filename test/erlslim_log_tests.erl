-module(erlslim_log_tests).
-include_lib("eunit/include/eunit.hrl").

set_and_get_log_path_test() ->
    Path = "/tmp/erlslim.log",
    erlslim_log:set_log_path(Path),
    ?assertEqual(Path, erlslim_log:get_log_path()).

set_default_path_when_error_is_path_argument_test() ->
    Path = "/tmp/default_erlslim.log",
    erlslim_log:set_log_path(error),
    ?assertEqual(Path, erlslim_log:get_log_path()).
 
get_log_path_without_setting_it_returns_default_tmp_test() ->
    Path = "/tmp/default_erlslim.log",
    ok = application:unset_env(erlslim, log_path),
    ?assertEqual(Path, erlslim_log:get_log_path()).

reset_log_file_test() ->
    Path = "/tmp/erlslim.log",
    ok = file:write_file(Path,"mumbo_jumbo_text"),
    erlslim_log:set_log_path(Path),
    erlslim_log:reset_log_file(),
    ?assertEqual({ok, <<>>} , file:read_file(Path)).

log_result_to_file_test() ->
    Path = "/tmp/erlslim.log",   
    erlslim_log:set_log_path(Path),
    erlslim_log:reset_log_file(),
    ID = "erlslim_log_ID",
    Result = [1,2,3],
    erlslim_log:log(ID, Result),
    {ok, Bin} = file:read_file(Path),
    [_,Logged] = string:tokens(binary_to_list(Bin),"|"),
    Expected = "erlslim_log_ID:[1,2,3]\n",
    ?assertEqual(Expected, Logged).
    
	
	
    
    
