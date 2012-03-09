-record(binding,{type :: list | bind | unbind,
		 arguments :: [{atom(),string()}]
		}).

-record(open,{port :: non_neg_integer(),
	      type :: string()
	     }).
