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
	    {ok, D, A} = handle_request(get, Socket, Transport, Data, []),
            Transport:send(Socket, "hello world");
	    %% loop(Socket, Transport);
        _ ->            
	    ok = Transport:close(Socket)
    end.

handle_request(get, Socket, Transport, Data, A) when Data =:= "\r\n" ->
    io:format("newline found"),
    handle_request(drop, Socket, Transport, Data, A);
handle_request(drop, _Socket, _Transport, Data, A) ->
    io:format("end of file~n"),
    {ok, Data, A};
handle_request(get, Socket, Transport, Data, A) ->
    io:format("<<"),
    io:format(Data),
    io:format(">>"),
    case Transport:recv(Socket, 0, 5000) of
        {ok, D} ->
	    handle_request(get, Socket, Transport, D, [D|A]);
	_ ->
	    handle_request(drop, Socket, Transport, Data, A)
    end.

	

    




