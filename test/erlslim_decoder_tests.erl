-module(erlslim_decoder_tests).
-include_lib("eunit/include/eunit.hrl").
-include("erlslim.hrl").

decode_script_naming_line_test() ->
    SlimLine = "000102:[000001:000085:[000004:000015:scriptTable_0_0:000004:make:000016:scriptTableActor:000009:my_module:]:]",
    ?assertEqual(#make{actor = my_module}, erlslim_decoder:decode(SlimLine)).
