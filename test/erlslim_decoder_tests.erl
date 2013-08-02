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
			args = ["Bob"]}
		 ], erlslim_decoder:decode(SlimLine)).
    
decode_bye_test() ->
    SlimLine = "000003:bye",
    ?assertEqual(#bye{id = "erlslim_server"}, 
		 erlslim_decoder:decode(SlimLine)).
    
decode_call_and_assign_test() ->
    SlimLine = "000243:[000002:"
	"000096:[000004:000016:scriptTable_13_0:000004:make:000016:scriptTableActor:000019:erlslim_demo_module:]:"
	"000122:[000005:000016:scriptTable_13_1:000013:callAndAssign:000008:Variable:000016:scriptTableActor:000020:getSystemTimeAndDate:]:"
	"]",
    ?assertEqual([#make{id = "scriptTable_13_0",
			actor = erlslim_demo_module},
		  #call_and_assign{id = "scriptTable_13_1",
				   call = #call{id = "scriptTable_13_1",
						function = getSystemTimeAndDate,
						args = []},
				   variable = "Variable"
				   }
		  ],
		 erlslim_decoder:decode(SlimLine)).
 
