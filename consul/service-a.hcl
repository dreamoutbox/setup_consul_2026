service {
	name    = "service-a"
	address = "service-a"
	port    = 0

	connect {
		sidecar_service {
			proxy {
				upstreams = [
					{
						destination_name    = "service-b"
						local_bind_address  = "127.0.0.1"
						local_bind_port     = 9002
					}
				]
			}
		}
	}
}

