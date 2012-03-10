all:
	erlc -o ebin/ -I src/ src/*.erl test/*.erl

dialyzer:
	dialyzer src/*.erl -I src/

eunit:
	erl -pa ebin/ -eval 'eunit:test(port,[verbose]),\
			     eunit:test(command,[verbose]),\
	 	 	     eunit:test(server,[verbose]),\
			     init:stop().'	