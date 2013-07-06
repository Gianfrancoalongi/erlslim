-module(erlslim).
-export([start/0]).
-define(LOG,"/tmp/erlslim.log").
-define(VERSION,"0.3").
-record(data,{lsock, asock, request, result, reply}).

start() -> 
    Steps = [fun start_slim_server/0,
	     fun clear_log/1,
	     fun accept_incoming_connection/1,
	     fun send_slim_protocol_version/1,
	     fun receive_slim_request/1,
	     fun handle_request/1,
	     fun send_response/1,
	     fun close_connections/1,
	     fun exit_with_code_zero/0
	    ],
    run_(Steps).

run_(Steps) ->
    run(Steps,undefined).

run([],_) ->
    [];
run([Step|T],State) ->
    log_state_to_file(State),
    case erlang:fun_info(Step,arity) of
	{arity,1} ->
	    run(T,Step(State));
	{arity,0} ->
	    run(T,Step())
    end.

start_slim_server() ->   
    {ok, [[Port]]} = init:get_argument('slim_port'),
    IPort = list_to_integer(Port),
    {ok, LSock} = gen_tcp:listen(IPort,[{active,false},{reuseaddr,true}]),
    #data{lsock = LSock}.

clear_log(Data) ->
    file:write_file(?LOG,""),
    Data.

accept_incoming_connection(Data) ->    
    {ok, ASock} = gen_tcp:accept(Data#data.lsock),
    Data#data{asock = ASock}.

send_slim_protocol_version(Data) ->
    gen_tcp:send(Data#data.asock,"Slim -- V"++?VERSION++"\n"),
    Data.

receive_slim_request(Data) ->
    {ok, [A,B,C,D,E,F]=TotalSize} = gen_tcp:recv(Data#data.asock, 6),
    {ok,_} = gen_tcp:recv(Data#data.asock,1),
    Bytes = list_to_integer(TotalSize),
    {ok, Received} = gen_tcp:recv(Data#data.asock, Bytes),
    Data#data{request = [A,B,C,D,E,F,$:|Received]}.

handle_request(Data) ->
    Res = erlslim_command:execute(erlslim_decoder:decode(Data#data.request)),
    Data#data{result = Res}.

send_response(Data) ->
    EncodedReply = erlslim_encoder:encode(Data#data.result),
    gen_tcp:send(Data#data.asock, EncodedReply),
    Data#data{reply = EncodedReply}.

close_connections(Data) ->
    gen_tcp:close(Data#data.asock),
    gen_tcp:close(Data#data.lsock).

exit_with_code_zero() ->
    exit(0).

log_state_to_file(State) ->
    file:write_file(?LOG,
		    io_lib:format("~p~n",[State]), 
		    [append]).
  
