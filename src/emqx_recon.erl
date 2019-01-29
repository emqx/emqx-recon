%% Copyright (c) 2013-2019 EMQ Technologies Co., Ltd. All Rights Reserved.
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

-module(emqx_recon).

-behaviour(application).
-export([start/2, stop/1]).

-behaviour(supervisor).
-export([init/1]).

-define(APP, ?MODULE).
-define(SUP, emqx_recon_sup).

start(_StartType, _StartArgs) ->
    emqx_recon_cli:load(),
    emqx_config:populate(?APP),
    supervisor:start_link({local, ?SUP}, ?MODULE, []).

stop(_State) ->
    emqx_recon_cli:unload().

init([]) ->
    GC = #{id => recon_gc,
           start => {emqx_recon_gc, start_link, []},
           restart => permanent,
           shutdown => 5000,
           type => worker,
           modules => [emqx_recon_gc]},
	{ok, {{one_for_one, 10, 100}, [GC]}}.
