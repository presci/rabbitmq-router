%%%-------------------------------------------------------------------
%%% @author prasad iyer <p.c.iyer@gmail.com>
%%% @copyright (C) 2014, prasad iyer
%%% @doc
%%%
%%% @end
%%% Created : 18 Mar 2014 by prasad iyer <p.c.iyer@gmail.com>
%%%-------------------------------------------------------------------
-module(rabbitmq_router).

-behaviour(application).


-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    rabbitmq_router_sup:start_link().

stop(_State) ->
    ok.
