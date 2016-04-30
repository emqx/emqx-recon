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

-module(emqttd_recon_SUITE).

-compile(export_all).

all() -> [{group, cli}].

groups() -> [{cli, [], [
                cli_memory,
                cli_allocated,
                cli_bin_leak,
                cli_node_stats,
                cli_remote_load]}
            ].

cli_memory(_) ->
    emqttd_recon:cli(["memory"]).

cli_allocated(_) ->
    emqttd_recon:cli(["allocated"]).
    
cli_bin_leak(_) ->
    emqttd_recon:cli(["bin_leak"]).

cli_node_stats(_) ->
    emqttd_recon:cli(["node_stats"]).

cli_remote_load(_) ->
    emqttd_recon:cli(["remote_load", "emqttd_recon"]).

