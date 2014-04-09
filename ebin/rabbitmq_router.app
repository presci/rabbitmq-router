{application,rabbitmq_router,
             [{description,"Embedded Rabbit Router"},
              {vsn,"0.01"},
              {modules,[my_queue,my_rabbit_protocol,my_worker,myrabbit,
                        rabbitmq_router_app,rabbitmq_router_sup,routingkeys]},
              {registered,[]},
              {mod,{rabbitmq_router_app,[]}},
              {env,[]},
              {applications,[kernel,stdlib,ranch,my_queue]}]}.
