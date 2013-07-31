-module(erlslim_command).
-include("erlslim.hrl").
-export([execute/1]).

execute(#bye{}=C) ->
    store_and_log_result(C#bye.id, ok);

execute(Commands) ->
    lists:map(fun execute_single_command/1, Commands).

execute_single_command(#make{}=C) ->    
    put(module, C#make.actor),
    store_and_log_result(C#make.id, ok);

execute_single_command(#call{}=C) ->
    Res = (catch apply(get(module), C#call.function, C#call.args)),
    store_and_log_result(C#call.id, Res).

store_and_log_result(Id, Res) ->
    erlslim_log:log(Id, Res),
    #result{id = Id, result = Res}.
    
