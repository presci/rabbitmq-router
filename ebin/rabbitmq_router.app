{application,rabbitmq_router,
             [{description,"Embedded Rabbit Router"},
              {vsn,"0.01"},
              {modules,[leaf,my_rabbit_protocol,rabbitmq_router,
                        rabbitmq_router_app,rabbitmq_router_sup]},
              {registered,[]},
              {mod,{rabbitmq_router_app,[]}},
              {env,[]},
              {applications,[kernel,stdlib,ranch]}]}.
