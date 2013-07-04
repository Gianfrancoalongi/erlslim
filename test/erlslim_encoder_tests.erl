-module(erlslim_encoder_tests).
-include("erlslim.hrl").
-include_lib("eunit/include/eunit.hrl").

encode_one_result_test() ->
    Res = [#result{id = "scriptTable_0_0", result = 'OK'}],
    ?assertEqual("000057:[000001:000043:[000002:000015:scriptTable_0_0:000002:OK:]:]",
		 erlslim_encoder:encode(Res) 
		).

encode_pid_result_test() ->
    Pid = list_to_pid("<0.40.0>"),
    Res = [#result{id = "scriptTable_0_0", result = Pid}],
    ?assertEqual("000063:[000001:000049:[000002:000015:scriptTable_0_0:000008:<0.40.0>:]:]",
		 erlslim_encoder:encode(Res) 
		).

					
