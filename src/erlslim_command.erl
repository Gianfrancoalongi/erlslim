-module(erlslim_command).
-include("erlslim.hrl").
-export([execute/1]).

execute(Commands) ->    
    lists:map(fun execute_single_command/1, Commands).

execute_single_command(#make{}=C) ->    
    put(module,C#make.actor),
    (C#make.actor):start_link(),
    #result{id=C#make.id,
	    result='OK'};
execute_single_command(#call{}=C) ->
    #result{id=C#call.id,
	    result=catch apply(get(module),
			       C#call.function,
			       C#call.args)
	   }.

