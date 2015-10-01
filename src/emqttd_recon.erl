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

-include_lib("emqttd/include/emqttd_cli.hrl").

-export([load/0, cli/1, unload/0]).

load() ->
    emqttd_ctl:register_cmd(recon, {?MODULE, cli}, []).

cli(["bin_leak"]) ->
    cli(["bin_leak", "100"]); 
cli(["bin_leak", N]) ->
    recon:bin_leak(list_to_integer(N));
cli(_) ->
    ?USAGE([{"recon", "recon bin_leak N"}]).

unload() ->
    emqttd_ctl:unregister_cmd(recon).
