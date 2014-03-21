-module(myrabbit).

-export([start/0]).
-export([stop/0]).


start()->
    application:start(ranch),
    application:start(rabbitmq_router),
    ok.



stop()->
    application:stop(rabbitmq_router).
