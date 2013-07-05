-module(erlslim_demo_module).
-export([aProcessNamedIsStarted/1,
	 thatTheProcessNamedHasAliveStatus/1,
	 sendStopMessageToTheProcessNamed/1,
	 start_link/0
	]).

start_link() ->
    ok.

aProcessNamedIsStarted(Name) ->
    Parent = self(),
    Ref = make_ref(),
    spawn(
      fun() ->
	      register(Name,self()),
	      Parent !  {started, Ref},
	      loop()
      end),
    receive
	{started, Ref} ->
	    ok
    end.


thatTheProcessNamedHasAliveStatus(Name) ->
    (undefined =/= whereis(Name)) andalso
	is_process_alive(whereis(Name)).


sendStopMessageToTheProcessNamed(Name) ->
    Pid = whereis(Name),
    Pid ! {stop,self()},
    receive
	{ok,Pid} ->
	    ok
    end.

loop() ->
    receive
	{stop,From} ->
	    From ! {ok,self()}
    end.
