-module(erlslim_decoder).
-include("erlslim.hrl").
-export([decode/1]).

decode("000003:bye") ->
    #bye{id = "erlslim_server"};
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

decode_in_list(Input) ->
    {List_elements, T} = length_and_rest(Input),
    decode_elements(List_elements,T).

decode_elements(1, Data) ->
    [ decode_2(Data) ];
decode_elements(N, Data) ->
    {Length, Rest}  = length_and_rest(Data),
    To_be_decoded = string:sub_string(Rest, 2 + Length),
    Sub_element = string:sub_string(Data,1, Length + 7),
    [ decode_2(Sub_element) | decode_elements(N-1, To_be_decoded) ].

to_command(List) ->
    lists:map(fun make_command/1, List).

make_command([ID,"make",_,X]) ->
    #make{id = ID,
	  actor = list_to_atom(X)};
make_command([ID,"call",_,F|Args]) ->
    #call{id = ID,
	  function = list_to_atom(F),
	  args = [ list_to_atom(A) || A <- Args ]
	 };
make_command([ID,"callAndAssign",Variable|Call]) ->
    #call_and_assign{id = ID,
		     call = make_command([ID,"call"|Call]),
		     variable = list_to_atom(Variable)
		    }.


length_and_rest([A,B,C,D,E,F,$:|T]) ->
    {list_to_integer([A,B,C,D,E,F]),T}.
