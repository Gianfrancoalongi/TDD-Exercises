all:
	erlc -o ebin/ -I src/ src/*.erl test/*.erl

eunit:
	erl -pa ebin/ -eval 'eunit:test(port,[verbose]),\
			     eunit:test(command,[verbose]),\
			     init:stop().'	