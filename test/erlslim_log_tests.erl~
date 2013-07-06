-module(erlslim_log_tests).
-include_lib("eunit/include/eunit.hrl").

set_and_get_log_path_test() ->
    Path = "/tmp/erlslim.log",
    erlslim_log:set_log_path(Path),
    ?assertEqual(Path, erlslim_log:get_log_path()).
    
    
