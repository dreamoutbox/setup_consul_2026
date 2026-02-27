service {
	name    = "service-b"
	address = "service-b"
	port    = 8080

	connect {
		sidecar_service {
			port = 20000

			proxy {
				local_service_address = "127.0.0.1"
				local_service_port    = 8080
			}
		}
	}
}

