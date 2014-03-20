%%%-------------------------------------------------------------------
%%% @author prasad iyer <p.c.iyer@gmail.com>
%%% @copyright (C) 2014, prasad iyer
%%% @doc
%%%
%%% @end
%%% Created : 18 Mar 2014 by prasad iyer <p.c.iyer@gmail.com>
%%%-------------------------------------------------------------------
-module(rabbitmq_router_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    {ok, {{one_for_one, 10, 10}, []}}.

				   

