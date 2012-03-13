-record(port,{type :: echo | string(),
	      socket :: gen_tcp:socket(),
	      number :: integer()
	     }).
