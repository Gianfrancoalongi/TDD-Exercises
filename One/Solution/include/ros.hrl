
-record(entry,{type :: string(),
	       sold :: integer(),
	       projected :: integer()
	      }).

-record(ros,{entries :: [#entry{}],
	     total :: integer()
	    }).
