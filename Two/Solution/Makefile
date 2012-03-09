all:
	erlc -o ebin/ src/*.erl test/*.erl

eunit:
	erl -pa ebin/ -eval 'eunit:test(port,[verbose]),\
			     eunit:test(command,[verbose]),\
			     init:stop().'	