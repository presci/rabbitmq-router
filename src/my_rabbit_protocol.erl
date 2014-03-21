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
	    io:format(Rest),
	    Transport:send(Socket, "HTTP/1.1 200 OK\r\n"),
	    Transport:send(Socket, "Content-Type: text/plain\r\n"),
	    Transport:send(Socket, "hello world\r\n\r\n"),
	    loop(Socket, Transport);
        _ ->            
	    ok = Transport:close(Socket)
    end.



	

    




