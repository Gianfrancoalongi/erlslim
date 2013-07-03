-module(erlslim_decoder).
-include("erlslim.hrl").
-export([decode/1]).

decode(Input) ->
    to_command(decode_2(Input)).

to_command([_,"make","scriptTableActor",X]) ->
    #make{actor = list_to_atom(X)}.

decode_2([]) -> [];
decode_2([$:|T]) -> decode_2(T);
decode_2([$]|T]) -> decode_2(T);
decode_2([A,B,C,D,E,F,$:|T]) ->
    Taken = string:sub_string(T,1,list_to_integer([A,B,C,D,E,F])),
    case Taken of
	[$[|_] = LIST ->
	    decode_2_list(LIST);
	_ ->
	    T3 = string:sub_string(T,1+list_to_integer([A,B,C,D,E,F])),
	    [Taken | decode_2(T3)]
    end.

decode_2_list([$[,_,_,_,_,_,_,$:|T]) ->
    decode_2(T).

    
