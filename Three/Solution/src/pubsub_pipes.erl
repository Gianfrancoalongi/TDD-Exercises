%%%-------------------------------------------------------------------
%%% @author Gianfranco Alongi <zenon@zentop.local>
%%% @copyright (C) 2012, Gianfranco Alongi
%%% Created : 21 Mar 2012 by Gianfranco Alongi <zenon@zentop.local>
%%%-------------------------------------------------------------------
-module(pubsub_pipes).
-behaviour(gen_server).

-export([new_pipe/1,
	 get_pipes/0
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

%%%===================================================================
init([]) ->
    {ok, #state{pipes = ets:new(pipes,[bag])}}.

handle_call(stop,_From,State) ->
    {stop,normal,ok,State};

handle_call({create_pipe,PipeName}, _From, State) ->
    ets:insert_new(State#state.pipes,{PipeName,[]}),
    {reply, ok, State};

handle_call(get_pipes,_From,State) ->
    Pipes = ets:foldl(fun({Key,_},Acc) -> [Key|Acc] end,
		      [],
		      State#state.pipes),
    {reply,Pipes, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
