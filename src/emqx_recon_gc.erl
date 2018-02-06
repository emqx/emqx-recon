%%--------------------------------------------------------------------
%% Copyright (c) 2013-2018 EMQ Enterprise, Inc. (http://emqtt.io)
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emqx_recon_gc).

-author("Feng Lee <feng@emqtt.io>").

-behaviour(gen_server).

%% API.
-export([start_link/0, run/0]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {timer}).

%% 5 minutes
-define(DEFAULT_INTERVAL, 300000).

%%--------------------------------------------------------------------
%% Start the GC server
%%--------------------------------------------------------------------

-spec(start_link() -> {ok, pid()}).
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

run() ->
    gen_server:call(?MODULE, run, infinity).

%%--------------------------------------------------------------------
%% gen_server Callbacks
%%--------------------------------------------------------------------

init([]) ->
    {ok, schedule_gc(#state{})}.

handle_call(run, _From, State) ->
    {Time, _} = timer:tc(fun run_gc/0),
    {reply, {ok, Time}, State, hibernate};

handle_call(_Req, _From, State) ->
	{reply, ignore, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(run, State) ->
    run_gc(),
	{noreply, schedule_gc(State), hibernate};

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%%--------------------------------------------------------------------
%% Internel function
%%--------------------------------------------------------------------

schedule_gc(State) ->
    Interval = application:get_env(emqx_recon, gc_interval, ?DEFAULT_INTERVAL),
    State#state{timer = erlang:send_after(Interval, self(), run)}.

run_gc() ->
    [garbage_collect(P) || P <- processes(), {status, waiting} == process_info(P, status)].

