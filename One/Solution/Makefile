all:
	erlc -o ebin/ src/*.erl test/*.erl

.PHONY: test

test:
	erl -pa ebin/ -eval 'eunit:test(ros_reader,[verbose]),\
			     eunit:test(ros_parser,[verbose]),\
		             eunit:test(ros_analyzer,[verbose]),\
	     		     eunit:test(ros_engine,[verbose]),\
			     eunit:test(ros,[verbose]),\
			     init:stop().'
