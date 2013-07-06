-module(seq_tests).
-include_lib("eunit/include/eunit.hrl").

no_steps_sequences_test() ->
    Steps = [],
    ?assertEqual([], seq:run_(Steps)).
