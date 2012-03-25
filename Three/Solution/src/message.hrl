-record(message,{pipe ::string(),
		 body :: binary(),
		 byte_size :: non_neg_integer()
		}).
-record(pipe_declaration,{type :: publish | subscribe}).
-record(message_ack,{id :: string()}).
