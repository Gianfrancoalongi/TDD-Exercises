-record(binding,{type :: list | bind | unbind,
		 arguments :: [{atom(),string()}]
		}).

-record(port,{type :: open | close | list,
	      arguments :: [{atom(),string() | non_neg_integer()}]
	     }).
