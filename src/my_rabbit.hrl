

-record(httpreq,{
	  connection=keep_alive,
	  vsn,
	  method,
	  path,
	  headers=[],
	  body = <<>>}).

-record(from, {sock, port, peer_addr, peer_port}).

-record(queues, {uri}).
