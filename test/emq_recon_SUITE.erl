%%--------------------------------------------------------------------
%% Copyright (c) 2013-2017 EMQ Enterprise, Inc. (http://emqtt.io)
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

-module(emq_recon_SUITE).

-compile(export_all).

all() ->
    [{group, cli}, {group, gc}].

groups() ->
    [{cli, [sequence],
      [cli_memory,
       cli_allocated,
       cli_bin_leak,
       cli_node_stats,
       cli_remote_load,
       cli_usage]},
     {gc, [sequence],
      [gc_run]}
    ].

init_per_suite(Config) ->
    [{ok, _} = application:ensure_all_started(App) || App <- [lager, emqttd, emq_recon]],
    Config.

end_per_suite(_Config) ->
    application:stop(emq_recon),
    application:stop(emqttd).

cli_memory(_) ->
    emq_recon_cli:cmd(["memory"]).

cli_allocated(_) ->
    emq_recon_cli:cmd(["allocated"]).
    
cli_bin_leak(_) ->
    emq_recon_cli:cmd(["bin_leak"]).

cli_node_stats(_) ->
    emq_recon_cli:cmd(["node_stats"]).

cli_remote_load(_) ->
    emq_recon_cli:cmd(["remote_load", "emq_recon_gc"]).

cli_usage(_) ->
    emq_recon_cli:cmd(["usage"]).

gc_run(_) ->
    {ok, Micros} = emq_recon_gc:run(),
    io:format("GC: ~p~n", [Micros]).

