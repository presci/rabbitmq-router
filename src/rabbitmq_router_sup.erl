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
    RanchSupSpec={ranch_sup, {ranch_sup, start_link, []},
		  permanent, 5000, supervisor, [ranch_sup]},
    ListenerSpec= ranch:child_spec(echo, 100, 
				   ranch_tcp, [{port, 5555}],
				   my_rabbit_protocol, []
				  ),
    {ok, {{one_for_one, 10, 10}, [RanchSupSpec, ListenerSpec]}}.

				   

