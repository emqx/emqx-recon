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

%% @doc Recon CLI
-module(emqttd_recon).

-include("../../../include/emqttd_cli.hrl").

-export([load/0, cli/1, unload/0]).

load() ->
    emqttd_ctl:register_cmd(recon, {?MODULE, cli}, []).

cli(["memory"]) ->
    Print = fun(Key, Keyword) ->
                ?PRINT("~-20s: ~w~n", [concat(Key, Keyword),
                                       recon_alloc:memory(Key, Keyword)])
            end,
    [Print(Key, Keyword) || Key <- [usage, used, allocated, unused],
                            Keyword <- [current, max]];

cli(["allocated"]) ->
    Print = fun(Keyword, Key, Val) ->
                ?PRINT("~-20s: ~w~n", [concat(Key, Keyword), Val])
            end,
    Alloc = fun(Keyword) -> recon_alloc:memory(allocated_types, Keyword) end,
    [Print(Keyword, Key, Val) || Keyword <- [current, max],
                                 {Key, Val} <- Alloc(Keyword)];

cli(["bin_leak"]) ->
    [?PRINT("~p~n", [Row]) || Row <- recon:bin_leak(100)];

cli(["node_stats"]) ->
    recon:node_stats_print(10, 1000);

cli(["remote_load", Mod]) ->
    ?PRINT("~p~n", [recon:remote_load(list_to_atom(Mod))]);

cli(_) ->
    ?USAGE([{"recon memory",          "recon_alloc:memory/2"},
            {"recon allocated",       "recon_alloc:memory(allocated_types, current|max)"},
            {"recon bin_leak",        "recon:bin_leak(100)"},
            {"recon node_stats",      "recon:node_stats(10, 1000)"},
            {"recon remote_load Mod", "recon:remote_load(Mod)"}]).

unload() ->
    emqttd_ctl:unregister_cmd(recon).

concat(Key, Keyword) ->
    lists:concat([atom_to_list(Key), "/", atom_to_list(Keyword)]).

