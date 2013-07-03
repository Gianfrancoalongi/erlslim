-module(erlslim_decoder).
-include("erlslim.hrl").
-export([decode/1]).

decode(Input) ->
    to_command(decode_2(Input)).

decode_2([_,_,_,_,_,_,$:|R]) ->
    case R of
	[$[|T] ->
	    [$],$:|T2] = lists:reverse(T),
	    decode_in_list(lists:reverse(T2));
	_ ->
	    R
    end.

decode_in_list([A,B,C,D,E,F,$:|T]) ->
    List_elements = list_to_integer([A,B,C,D,E,F]),
    decode_elements(List_elements,T).

decode_elements(1, Data) ->
    [ decode_2(Data) ];
decode_elements(N, [A, B, C, D, E, F, $:|T]) ->
    Length = list_to_integer([A,B,C,D,E,F]),
    Taken = string:sub_string(T, 1, Length),
    Rest = string:sub_string(T, 2 + Length),
    [ decode_2([A,B,C,D,E,F,$:|Taken]) | decode_elements(N-1, Rest) ].


to_command(List) ->
    lists:map(fun make_command/1, List).

make_command([_,"make","scriptTableActor",X]) ->
    #make{actor = list_to_atom(X)};
make_command([_,"call","scriptTableActor",F|Args]) ->
    #call{function = list_to_atom(F),
	  args = [ list_to_atom(A) || A <- Args ]
	 }.
		  

