-module(erlslim_log).
-export([set_log_path/1,
	 get_log_path/0,
	 reset_log_file/0
	 ]).
-define(DEFAULT_LOG_PATH,"/tmp/default_erlslim.log").

set_log_path(Path) ->
    application:set_env(erlslim, log_path, Path).

get_log_path() ->
    case application:get_env(erlslim, log_path) of
	{ok, Path } ->
	    Path;
	undefined ->
	    ?DEFAULT_LOG_PATH
    end.

reset_log_file() ->
    file:write_file(get_log_path(),"").
