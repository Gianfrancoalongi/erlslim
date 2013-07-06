-module(erlslim_command_tests).
-include_lib("eunit/include/eunit.hrl").
-include("erlslim.hrl").

no_commands_test() ->
    Commands = [],
    ?assertEqual([], erlslim_command:execute(Commands)).

make_command_test() ->
    Commands = [#make{id = "make_command_test", actor = lists}],
    ?assertEqual([#result{id = "make_command_test", result = lists}],
		 erlslim_command:execute(Commands)).
