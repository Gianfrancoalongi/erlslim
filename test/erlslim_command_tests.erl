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
    
bye_test() ->
    Command = #bye{id = "erlslim_server"},
    ?assertEqual(#result{id = "erlslim_server", result = ok},
		  erlslim_command:execute(Command)).


call_and_assign_test() ->
    Commands = [#make{id = "cas_1", actor = string},
		#call_and_assign{id = "cas_2",
				 call = #call{id = "cas_2",
					      function = strip,
					      args = [" b "]},
				 variable = stripped
				 }
	       ],
    ?assertEqual([#result{id = "cas_1", result = ok},
		  #result{id = "cas_2", result = "b"}
		  ],
		 erlslim_command:execute(Commands)),
    ?assertEqual("b", erlslim_command:get_symbol(stripped)).
			  
call_and_assign_followed_by_use_of_symbol_test() ->
    Commands = [#make{id = "cas_1", actor = string},
		#call_and_assign{id = "cas_2",
				 call = #call{id = "cas_2",
					      function = strip,
					      args = [" a,b,a "]},
				 variable = "stripped"
				 },
		#call{id = "cas_3",
		      function = tokens,
		      args = ["$stripped",","]
		      }
	       ],
    ?assertMatch([_,_,
		  #result{id = "cas_3",
			  result = ["a","b","a"]}
		 ],
		 erlslim_command:execute(Commands)).
    
