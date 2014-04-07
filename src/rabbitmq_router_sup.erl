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
    My_queue=[{my_queue, {my_queue, start_link, [{hello, "world"}]},
	    permanent, brutal_kill, worker, [my_queue]}],
    {ok, {{one_for_one, 1, 60}, My_queue
	  }}.


				   

