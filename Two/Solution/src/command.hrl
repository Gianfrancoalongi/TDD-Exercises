-record(binding_command,{type :: list | bind | unbind,
			 arguments :: [{atom(),string()}]
			}).

-record(port_command,{type :: open | close | list,
		      arguments :: [{atom(),string() | non_neg_integer()}]
		     }).
