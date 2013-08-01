-module(erlslim_command).
-include("erlslim.hrl").
-export([execute/1,
	 get_symbol/1
	]).
-define(VAR_TABLE, erlslim_var_table).

execute(#bye{}=C) ->
    store_and_log_result(C#bye.id, ok);

execute(Commands) ->
    lists:map(fun execute_single_command/1, Commands).


get_symbol(Symbol) ->
    case table_exists() of 
	true ->
	    [{Symbol,Val}] = ets:lookup(?VAR_TABLE, Symbol),
	    Val;
	false ->
	    undefined
    end.

execute_single_command(#make{}=C) ->    
    put(module, C#make.actor),
    store_and_log_result(C#make.id, ok);

execute_single_command(#call{}=C) ->
    Res = (catch apply(get(module), C#call.function, C#call.args)),
    store_and_log_result(C#call.id, Res);

execute_single_command(#call_and_assign{}=C) ->
    Res = execute_single_command(C#call_and_assign.call),
    store_result_with_variable(C#call_and_assign.variable, Res#result.result),
    Res.

store_and_log_result(Id, Res) ->
    erlslim_log:log(Id, Res),
    #result{id = Id, result = Res}.
    
store_result_with_variable(Variable, Value) ->
    create_variable_table_if_needed(),
    ets:insert(?VAR_TABLE, {Variable, Value}).

create_variable_table_if_needed() ->
    case table_exists() of
	true ->
	    ok;
	false ->
	    ets:new(?VAR_TABLE, [bag, named_table])
    end.
    
table_exists() ->
    undefined =/= ets:info(?VAR_TABLE).

