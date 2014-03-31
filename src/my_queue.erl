-module(my_queue).

-export([start/2]).

-include("my_rabbit.hrl").

start(Dispatch, Queue)->
    URI = ets:new ( 'uri', [] ),
    ok=populate('uri', Dispatch, Queue),
    {ok, URI}.



populate(_, [], _)->    
    ok;
populate(_URI, [H|T], Queue) when Queue == true-> 
    ets:insert(_URI, H),
    populate(_URI, T, Queue);
populate(_URI, [H|T], Queue) -> 
    ets:insert(_URI, H),
    populate(_URI, T, Queue).
