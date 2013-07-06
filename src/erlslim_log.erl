-module(erlslim_log).
-export([set_log_path/1,
	 get_log_path/0
	 ]).

set_log_path(Path) ->
    application:set_env(erlslim, log_path, Path).

get_log_path() ->
    {ok, Path } = application:get_env(erlslim, log_path),
    Path.
