-module(erlslim).
-export([start/0]).
-define(VERSION,"0.3").

start() ->    
    {ok, [[Port]]} = init:get_argument('slim_port'),
    {ok, LSock} = gen_tcp:listen(list_to_integer(Port),[{active,false},
							{reuseaddr,true}]),
    {ok, ASock} = gen_tcp:accept(LSock),
    gen_tcp:send(ASock,"Slim -- V"++?VERSION++"\n"),
    {ok, Data} = gen_tcp:recv(ASock, 0),
    io:format("Received:~p~n",[Data]),
    handle_command(ASock, Data),
    gen_tcp:close(ASock),
    gen_tcp:close(LSock),
    exit(0).

handle_command(_, "000003:bye") ->
    io:format("BYE~n",[]);
handle_command(ASock, Input) ->
    io:format("command: ~p ~n",[erlslim_decoder:decode(Input)]),
    gen_tcp:send(ASock,"000019:[000001:000002:OK:]").

