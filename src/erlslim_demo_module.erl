-module(erlslim_demo_module).
-export([aProcessNamedIsStarted/1,
	 thatTheProcessNamedHasAliveStatus/1
	]).

aProcessNamedIsStarted(Name) ->
    spawn(
      fun() ->
	      register(Name,self()),
	      loop()
      end).


thatTheProcessNamedHasAliveStatus(Name) ->
    (undefined =/= whereis(Name)) andalso
	is_process_alive(whereis(Name)).


loop() ->
    receive
	stop ->
	    ok
    end.
