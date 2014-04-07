-module(my_rabbit_protocol).
-behaviour(ranch_protocol).

-include("my_rabbit.hrl").

-export([start_link/4, init/4]).




start_link(Ref, Socket, Transport, Opts) ->
    Pid = spawn_link(?MODULE, init, [Ref, Socket, Transport, Opts]),
        {ok, Pid}.
 
init(Ref, Socket, Transport, _Opts = []) ->
    ok = ranch:accept_ack(Ref),
        loop(Socket, Transport).
 %% http://goo.gl/o2fTRP
loop(Socket, Transport) ->
    case Transport:recv(Socket, 0, 5000) of
        {ok, Data} -> {ok, {
			 http_request, 
			 Method, 
			 Path, 
			 Version}, 
		       Rest} = erlang:decode_packet(http, Data, []),
	    Headers=get_headers(
		      binary:split(Rest, <<"\r\n">>,[global]), []),
	    Req=#httpreq{
	      method=Method, 
	      path=Path, 
	      vsn=Version, headers=Headers},
	    Transport:send(Socket, "hello world"),
	    loop(Socket, Transport);
        _ ->            
	    ok = Transport:close(Socket)
    end.

get_headers([H|T], A) ->
    He=get_header_kv(H),
    get_headers(T,  A ++ [He]);
get_headers([], A) ->
    A.

get_header_kv(H) when H =:= <<"">> ->
    [];
get_header_kv(H) ->
    [X, Y] = binary:split(H, <<":">>),
    [{X, Y}].
    




