-module(my_rabbit_protocol).
-behaviour(ranch_protocol).

-export([start_link/4, init/4]).


-record( c, {
	   sock, port, peer_addr, peer_port}).
-record(req, {
	  connection=keep_alive,
	  content_length,
	  vsn,
	  method,
	  uri,
	  args="",
	  headers,
	  body = <<>>}).


start_link(Ref, Socket, Transport, Opts) ->
    Pid = spawn_link(?MODULE, init, [Ref, Socket, Transport, Opts]),
        {ok, Pid}.
 
init(Ref, Socket, Transport, _Opts = []) ->
    ok = ranch:accept_ack(Ref),
        loop(Socket, Transport).
 %% http://goo.gl/o2fTRP
loop(Socket, Transport) ->
    case Transport:recv(Socket, 0, 5000) of
        {ok, Data} ->
	    {ok, {http_request, Method, Path, Version}, Rest} = erlang:decode_packet(http, Data, []),
	    Headers = get_headers(binary:split(Rest, <<"\n">>), []),
	    io:format("returning~n"),
	    Transport:send(Socket, "hello world"),
	    loop(Socket, Transport);
        _ ->            
	    ok = Transport:close(Socket)
    end.

get_headers([H|T], A) ->
    io:format(H),
    get_headers(T,  A ++ [H]);
get_headers([], A) ->
    A.


	

    




