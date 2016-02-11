%%--------------------------------------------------------------------
%% Copyright (c) 2015-2016 Feng Lee <feng@emqtt.io>.
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

%% @doc emqttd recon plugin
-module(emqttd_recon_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-behaviour(supervisor).

%% Supervisor callbacks
-export([init/1]).

%%--------------------------------------------------------------------
%% Application callbacks
%%--------------------------------------------------------------------

start(_StartType, _StartArgs) ->
    emqttd_recon:load(),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

stop(_State) ->
    emqttd_recon:unload(),
    ok.

%%--------------------------------------------------------------------
%% Supervisor callbacks(Dummy)
%%--------------------------------------------------------------------

init([]) ->
    {ok, { {one_for_one, 5, 10}, []} }.

