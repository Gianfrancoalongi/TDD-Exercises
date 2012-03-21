%%%-------------------------------------------------------------------
%%% @author Gianfranco Alongi <zenon@zentop.local>
%%% @copyright (C) 2012, Gianfranco Alongi
%%% Created : 21 Mar 2012 by Gianfranco Alongi <zenon@zentop.local>
%%%-------------------------------------------------------------------
-module(pubsub_pipes).
-behaviour(gen_server).

-export([new_pipe/1,
	 get_pipes/0,
	 subscribe_to_pipe/1,
	 get_subscribers_to_pipe/1,
	 unsubscribe_from_pipe/1
	 ]).
-export([start_link/0,
	 stop/0
	]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-record(state, {pipes :: atom() %% ets table
	       }).

%%%===================================================================
start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:call(?MODULE,stop).

-spec(new_pipe(string()) -> ok).
new_pipe(PipeName) ->
    gen_server:call(?MODULE,{create_pipe,PipeName}).

-spec(get_pipes() -> [string()]).
get_pipes() ->
    gen_server:call(?MODULE,get_pipes).

-spec(subscribe_to_pipe(string()) -> ok).
subscribe_to_pipe(PipeName) ->
    gen_server:call(?MODULE,{subscribe_to_pipe,PipeName,self()}).

-spec(get_subscribers_to_pipe(string()) -> [string()]).
get_subscribers_to_pipe(PipeName) ->
    gen_server:call(?MODULE,{get_subscribers_to_pipe,PipeName}).

-spec(unsubscribe_from_pipe(string()) -> ok).
unsubscribe_from_pipe(PipeName) ->
    gen_server:call(?MODULE,{unsubscribe_from_pipe,PipeName,self()}).

%%%===================================================================
init([]) ->
    {ok, #state{pipes = ets:new(pipes,[set])}}.

handle_call(stop,_From,State) ->
    {stop,normal,ok,State};

handle_call({create_pipe,PipeName}, _From, State) ->
    ets:insert_new(State#state.pipes,{PipeName,[]}),
    {reply, ok, State};

handle_call(get_pipes,_From,State) ->
    Pipes = ets:foldl(fun({Key,_},Acc) -> [Key|Acc] end,
		      [],
		      State#state.pipes),
    {reply,Pipes, State};

handle_call({subscribe_to_pipe,PipeName,Pid},_From,State) ->
    [{PipeName,Subscribers}] = ets:lookup(State#state.pipes,PipeName),
    ets:insert(State#state.pipes,[{PipeName,[Pid|Subscribers]}]),
    {reply,ok,State};

handle_call({get_subscribers_to_pipe,PipeName},_From,State) ->
    [{PipeName,Subscribers}] = ets:lookup(State#state.pipes,PipeName),
    {reply,Subscribers,State};

handle_call({unsubscribe_from_pipe,PipeName,Pid},_From,State) ->
    [{PipeName,Subscribers}] = ets:lookup(State#state.pipes,PipeName),
    Removed = [ X || X <- Subscribers, X =/= Pid],
    ets:insert(State#state.pipes,[{PipeName,Removed}]),
    {reply,ok,State}.


handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
