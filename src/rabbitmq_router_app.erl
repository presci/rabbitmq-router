%%%-------------------------------------------------------------------
%%% @author prasad iyer <p.c.iyer@gmail.com>
%%% @copyright (C) 2014, prasad iyer
%%% @doc
%%%
%%% @end
%%% Created : 18 Mar 2014 by prasad iyer <p.c.iyer@gmail.com>
%%%-------------------------------------------------------------------
-module(rabbitmq_router_app).

-behaviour(application).


-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ensure_started(ranch),
    {ok, _} = ranch:start_listener(rabbitmq_router, 1,
				   ranch_tcp, [{port, 5555}], my_rabbit_protocol, []),
    rabbitmq_router_sup:start_link().

stop(_State) ->
    ok.


%% private
ensure_started(App)->
    case application:start(App) of
	ok ->
	    ok;
	{error, {already_started, App}} ->
	    ok
    end.
