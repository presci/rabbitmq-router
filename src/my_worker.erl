%%%-------------------------------------------------------------------
%%% @author prasad iyer <prasad@gmx.com>
%%% @copyright (C) 2014, prasad iyer
%%% @doc
%%%
%%% @end
%%% Created :  8 Apr 2014 by prasad iyer <prasad@gmx.com>
%%%-------------------------------------------------------------------
-module(my_worker).

-include("my_rabbit.hrl").

-export([start_link/3, init/1, loop/1]).
-export([system_continue/3, system_terminate/4, system_code_change/4]).

start_link(Socket, Transport, Req)->
    proc_lib:start_link(?MODULE, init, [{self(), Socket, Transport, Req}]).

init(A)->
    proc_lib:init_ack({ok, self()}),
    loop(A).

loop({Parent, Socket, Transport, Req})->
    %% Corr = generate(),
    gen_server:cast(my_queue, {msg,  "discovery", self(), Req}),
    receive 
	{amqpmsg, A}->
	    %% send message back to client
	    Transport:send(Socket, A);
	 {'EXIT', Parent, Reason}->
	    exit(Reason);
	{system, From, Request} ->
	    sys:handle_system_msg(Request, 
				  From, Parent, 
				  ?MODULE, [], {state, Parent})
    end.



system_continue(_, _, {state, A}) ->    
    loop(A).
system_terminate(Reason, _, _, _) ->
    exit(Reason).
system_code_change(Misc, _, _, _)->
    {ok, Misc}.









