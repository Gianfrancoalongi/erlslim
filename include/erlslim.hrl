-record(make,{actor :: atom()}).
-record(call,{function :: atom(),
	      args :: [ atom() | string() ]}).
