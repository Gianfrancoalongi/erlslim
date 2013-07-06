-module(erlslim_command).
-include("erlslim.hrl").
-define(LOG,"/tmp/erlslim.log").
-export([execute/1]).

execute(Commands) ->
    lists:map(fun execute_single_command/1, Commands).

execute_single_command(#make{}=C) ->    
    put(module, C#make.actor),
    Res = (catch (C#make.actor):start_link()),
    store_and_log_result(C#make.id, Res);

execute_single_command(#call{}=C) ->
    Res = (catch apply(get(module), C#call.function, C#call.args)),
    store_and_log_result(C#call.id, Res).

store_and_log_result(Id, Res) ->
    file:write_file(?LOG,io_lib:format("~p:~p:~p|~s:~p~n",[date(),time(),now(),Id,Res]),[append]),
    #result{id = Id, result = Res}.
    
