-module(seq_tests).
-include_lib("eunit/include/eunit.hrl").

no_steps_sequences_test() ->
    Steps = [],
    ?assertEqual(undefined, seq:run_(Steps)).

data_generation_in_seq_test() ->
    Steps = [fun() -> 1 end],
    ?assertEqual(1, seq:run_(Steps)).
		 
data_consumer_in_seq_test() ->    
    Steps = [fun() -> 1 end,
	     fun(X) -> X+1 end
	    ],
    ?assertEqual(2, seq:run_(Steps)).
		      
		     
