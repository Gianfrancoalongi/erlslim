-module(erlslim_encoder_tests).
-include("erlslim.hrl").
-include_lib("eunit/include/eunit.hrl").

encode_one_result_test() ->
    Res = [#result{id = "scriptTable_0_0", result = 'OK'}],
    ?assertEqual("000057:[000001:000043:[000002:000015:scriptTable_0_0:000002:OK:]:]",
		 erlslim_encoder:encode(Res) 
		).



					
