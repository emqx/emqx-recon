%%%-----------------------------------------------------------------------------
%%% @Copyright (C) 2015, Feng Lee <feng@emqtt.io>
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in all
%%% copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%%% SOFTWARE.
%%%-----------------------------------------------------------------------------
%%% @doc
%%% recon cli
%%%
%%% @end
%%%-----------------------------------------------------------------------------

-module(emqttd_recon).

-author("Feng Lee <feng@emqtt.io>").

-include_lib("emqttd/include/emqttd_cli.hrl").

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
    ?PRINT("~p~n", [recon:bin_leak(100)]);

cli(["node_stats"]) ->
    recon:node_stats_print(10, 1000);

cli(["remote_load", Mod]) ->
    ?PRINT("~p~n", [recon:remote_load(list_to_atom(Mod))]);

cli(_) ->
    ?USAGE([{"recon memory",          "recon_alloc:memory/2"},
            {"recon allocated"        "recon_alloc:memory(allocated_types, current|max)"},
            {"recon bin_leak",        "recon:bin_leak(100)"},
            {"recon node_stats",      "recon:node_stats(10, 1000)"},
            {"recon remote_load Mod", "recon:remote_load(Mod)"}]).

unload() ->
    emqttd_ctl:unregister_cmd(recon).

concat(Key, Keyword) ->
    lists:concat([atom_to_list(Key), "/", atom_to_list(Keyword)]).
