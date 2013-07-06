-module(erlslim_command_tests).
-include_lib("eunit/include/eunit.hrl").
-include("erlslim.hrl").

no_commands_test() ->
    Commands = [],
    ?assertEqual([], erlslim_command:execute(Commands)).

make_command_test() ->
    Commands = [#make{id = "make_command_test", actor = lists}],
    ?assertEqual([#result{id = "make_command_test", result = ok}],
		 erlslim_command:execute(Commands)),
    ?assertEqual(lists,get(module)).

call_command_test() ->
    Commands = [#make{id = "call_command_test_1", actor = string},
		#call{id = "call_command_test_2", 
		      function = strip,
		      args = [" a "]}
	       ],
    ?assertEqual([#result{id = "call_command_test_1", result = ok},
		  #result{id = "call_command_test_2", result = "a"}
		  ],
		 erlslim_command:execute(Commands)).
    
