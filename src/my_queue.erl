%%%-------------------------------------------------------------------
%%% @author prasad iyer <prasad@gmx.com>
%%% @copyright (C) 2014, prasad iyer
%%% @doc
%%%
%%% @end
%%% Created :  4 Apr 2014 by prasad iyer <prasad.iyer@gmx.com>
%%%-------------------------------------------------------------------
-module(my_queue).

-behaviour(gen_server).

%% -include("amqp_client.hrl").
%% API

-include_lib("amqp_client/include/amqp_client.hrl").
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


init([]) ->
    create_queues(),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.



%%%
%%% internal function
create_queues()->
    {ok, User}=application:get_env(rabbitmq_router, <<"guest">>),
    {ok, Password}=application:get_env(rabbitmq_router, <<"guest">>),
    {ok, Vhost}=application:get_env(rabbitmq_router, <<"/">>),
    {ok, Host}=application:get_env(rabbitmq_router, "localhost"),
    {ok, Port}=application:get_env(rabbitmq_router, 5672),
    {ok, Exchange} = application:get_env(rabbitmq_router, "RouterExchange"),
    {ok, Queue}=application:get_env(rabbitmq_router, <<"RouterQueue">>),
    Routing_key = routing_keys:get_routing_keys(),
    ConnParams = #amqp_params{username=User, password=Password,
			      virtual_host=Vhost, host=Host, 
			      port=Port},
    {ok, Connection}=amqp_connection:start(network, ConnParams),
    {ok, Chann}=amqp_connection:open_channel(Connection),
    amqp_channel:call(Chann, 
		      #'exchange.declare'{
			exchange = Exchange, 
			type = <<"x-recent-history">>, 
			durable = true}),
    amqp_channel:call(Chann, #'queue.declare'{queue = Queue}),
    create_routing(Routing_key, Queue, Exchange, Chann).


create_routing([H|T], Queue, Exchange, Chann)->
    amqp_channel:call(Chann, #'queue.bind'{
			queue = Queue,
			exchange = Exchange,
			routing_key = H}),
    create_routing(T, Queue, Exchange, Chann);
create_routing([], _, _, _ ) ->
    ok.

		      








    
