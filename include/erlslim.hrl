-record(make,{id :: string(),
	      actor :: atom()}).
-record(call,{id :: string(),
	      function :: atom(),
	      args :: [ atom() | string() ]}).
-record(result,{id :: string(),
		result :: term() }).
