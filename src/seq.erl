-module(seq).
-export([run_/1]).

run_(Steps) ->
    run(Steps,undefined).

run([],State) ->
    State;
run([Step|T],State) ->
    case erlang:fun_info(Step,arity) of
	{arity,1} ->
	    run(T,Step(State));
	{arity,0} ->
	    run(T,Step())
    end.

