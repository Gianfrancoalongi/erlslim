-module(erlslim_command).
-include("erlslim.hrl").
-export([execute/1]).

execute(Commands) ->
    lists:map(
      fun(#make{}=C) ->
	      put(module,C#make.actor),
	      #result{id=C#make.id,
		      result='OK'};
	 (#call{}=C) ->
	      #result{id=C#call.id,
		      result=apply(get(module),
				   C#call.function,
				   C#call.args)
		      }
      end,
      Commands).
