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

-module(emqx_recon_SUITE).

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
    DataDir = proplists:get_value(data_dir, Config),
    [start_apps(App, DataDir) || App <- [emqx, emqx_recon]],
    Config.

end_per_suite(_Config) ->
    application:stop(emqx_recon),
    application:stop(emqx).

cli_memory(_) ->
    emqx_recon_cli:cmd(["memory"]).

cli_allocated(_) ->
    emqx_recon_cli:cmd(["allocated"]).

cli_bin_leak(_) ->
    emqx_recon_cli:cmd(["bin_leak"]).

cli_node_stats(_) ->
    emqx_recon_cli:cmd(["node_stats"]).

cli_remote_load(_) ->
    emqx_recon_cli:cmd(["remote_load", "emqx_recon_gc"]).

cli_usage(_) ->
    emqx_recon_cli:cmd(["usage"]).

gc_run(_) ->
    {ok, Micros} = emqx_recon_gc:run(),
    ct:print("GC: ~p~n", [Micros]).

start_apps(App, DataDir) ->
    Schema = cuttlefish_schema:files([filename:join([DataDir, atom_to_list(App) ++ ".schema"])]),
    Conf = conf_parse:file(filename:join([DataDir, atom_to_list(App) ++ ".conf"])),
    NewConfig = cuttlefish_generator:map(Schema, Conf),
    Vals = proplists:get_value(App, NewConfig),
    [application:set_env(App, Par, Value) || {Par, Value} <- Vals],
    application:ensure_all_started(App).

