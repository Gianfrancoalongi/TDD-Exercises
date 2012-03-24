%%%-------------------------------------------------------------------
%%% @author Gianfranco Alongi <zenon@zentop.local>
%%% @copyright (C) 2012, Gianfranco Alongi
%%% Created : 21 Mar 2012 by Gianfranco Alongi <zenon@zentop.local>
%%%-------------------------------------------------------------------
-module(pubsub_client_port).
-behaviour(gen_server).
-include("message.hrl").

%% API
-export([start_link/0,
	 get_type/1,
	 handle_msg/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-record(state, {type = none :: publish | subscribe | none}).

%%%===================================================================
start_link() ->
    gen_server:start_link(?MODULE, [], []).

-spec(get_type(pid()) -> publish | subscribe | none).
get_type(Pid) ->
    gen_server:call(Pid,get_type).


-spec(handle_msg(pid(),#pipe_declaration{}) -> ok).
handle_msg(Pid,Msg) ->
    gen_server:call(Pid,{handle_msg,Msg}).

%%%===================================================================
init([]) ->
    {ok, #state{}}.

handle_call(get_type, _From, State) ->
    {reply,State#state.type, State};
handle_call({handle_msg,#pipe_declaration{type = Type}},_From,State) ->
    {reply,ok,State#state{type = Type}}.


handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================

