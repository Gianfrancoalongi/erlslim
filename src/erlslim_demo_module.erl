-module(erlslim_demo_module).
-export([aProcessNamedIsStarted/1]).

aProcessNamedIsStarted(Name) ->
    spawn_link(
      fun() ->
	      register(Name,self())
      end).
