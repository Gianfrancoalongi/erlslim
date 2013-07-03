-module(erlslim_decoder_tests).
-include_lib("eunit/include/eunit.hrl").
-include("erlslim.hrl").

decode_script_naming_line_test() ->
    SlimLine = "000102:[000001:000085:[000004:000015:scriptTable_0_0:000004:make:000016:scriptTableActor:000009:my_module:]:]",
    ?assertEqual([#make{id = "scriptTable_0_0",
			actor = my_module}
		 ], erlslim_decoder:decode(SlimLine)).

decode_two_lines_test() ->
    SlimLine =  "000219:[000002:000085:[000004:000015:scriptTable_0_0:000004:make:000016:scriptTableActor:000009:my_module:]:000109:[000005:000015:scriptTable_0_1:000004:call:000016:scriptTableActor:000022:aProcessNamedIsStarted:000003:Bob:]:]",
    ?assertEqual([#make{id = "scriptTable_0_0",
			actor = my_module},
		  #call{id = "scriptTable_0_1",
			function = aProcessNamedIsStarted,
			args = ['Bob']}
		 ], erlslim_decoder:decode(SlimLine)).
    


