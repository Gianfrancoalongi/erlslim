-module(erlslim_command_tests).
-include_lib("eunit/include/eunit.hrl").

no_commands_test() ->
    Commands = [],
    ?assertEqual([], erlslim_command:execute(Commands)).
