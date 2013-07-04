-module(erlslim_encoder).
-include("erlslim.hrl").
-export([encode/1]).

encode(Results) ->
    Encoded_results = lists:map(fun encode_result/1, Results),
    merge_to_one_result(Encoded_results).

encode_result(#result{}=R) ->
    String_result = atom_to_list(R#result.result),
    Formatted = lists:flatten(io_lib:format(":[000002:~6..0B:~s:~6..0B:~s:]",
					    [length(R#result.id),
					     R#result.id,
					     length(String_result),
					     String_result
					    ])),
    Size = length(Formatted),
    lists:flatten(io_lib:format("~6..0B~s",[Size,Formatted])).

merge_to_one_result(Encoded_results) ->
    Amount_of_elements = length(Encoded_results),
    Base_format_string = lists:flatten(io_lib:format("[~6..0B",[Amount_of_elements])),
    Total = lists:foldl(
	      fun(Encoded,Format_string) ->
		      lists:flatten(io_lib:format("~s:~s",[Format_string,Encoded]))
	      end,
	      Base_format_string,
	      Encoded_results),
    lists:flatten(io_lib:format("~6..0B:~s:]",[length(Total),Total])).
