all:
	erlc -o ebin/ src/*.erl test/*.erl

.PHONY: test

test:
	erl -pa ebin/ -eval 'eunit:test(ros_reader,[verbose]),init:stop().'