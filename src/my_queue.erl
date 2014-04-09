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
-include("my_rabbit.hrl").

-export([start_link/0, create_queues/0, test/0]).
-define(REPLY_TO, "replyqueue").

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

test()->
    gen_server:cast(?MODULE, {test, "discovery"}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


init([]) ->
    State = ets:new(corr_pid, [ordered_set, named_table]),
%%    create_queues(),
    {ok, State}.

handle_call(_Req, _From, State) ->
    {noreply, State}.


handle_cast({msg,  Corr, Pid, _Req}, State) ->
    ets:insert(State, {Corr, Pid}),
    {noreply, State};
handle_cast({test, Corr}, State) ->
    case ets:lookup(State, Corr) of
	[{Corr, Pid}] ->
	    ets:delete(State, Corr),
	    Pid ! {amqpmsg, "hello world"};
	[] ->
	    none
    end,
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
    {ok, User} = application:get_env(rabbitmq_router, <<"guest">>),
    {ok, Password} = application:get_env(rabbitmq_router, <<"guest">>),
    {ok, Vhost} = application:get_env(rabbitmq_router, <<"/">>),
    {ok, Host} = application:get_env(rabbitmq_router, "localhost"),
    {ok, Port} = application:get_env(rabbitmq_router, 5672),
    {ok, Exchange} =  application:get_env(rabbitmq_router, "RouterExchange"),
    {ok, Queue} = application:get_env(rabbitmq_router, <<"RouterQueue">>),
    Routing_key = routing_keys:get_routing_keys(),
    ConnParams = #amqp_params{username=User, password=Password,
			      virtual_host=Vhost, host=Host, 
			      port=Port},
    {ok, Connection} = amqp_connection:start(network, ConnParams),
    {ok, Chann} = amqp_connection:open_channel(Connection),
    amqp_channel:call(Chann, 
		      #'exchange.declare'{
			exchange = Exchange, 
			type = <<"x-recent-history">>, 
			durable = true}),
    amqp_channel:call(Chann, #'queue.declare'{queue = Queue}),
    amqp_channel:call(Chann, #'queue.declare'{queue = ?REPLY_TO}),
    create_routing(Routing_key, Queue, Exchange, Chann).

create_routing([{Method, Uri}|T], Queue, Exchange, Chann)->
    J=string:join([Method, Uri], ":"),
    amqp_channel:call(Chann, #'queue.bind'{
			queue = Queue,
			exchange = Exchange,
			routing_key = J}),
    create_routing(T, Queue, Exchange, Chann);
create_routing([], _, _, _ ) ->
    ok.

		      








    
