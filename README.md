# setup_consul_2026
trying service mesh consul

## Quickstart

Run it!
```bash
docker compose down && docker compose up -d --build

```

See sidecar logs
```bash
docker logs service-a-sidecar
docker logs service-b-sidecar
```

See services logs
```bash
docker logs service-a
docker logs service-b
```

and you should see output like this
```
Start service-a
error request to service-b Get "http://localhost:9191": dial tcp [::1]:9191: connect: connection refused
error request to service-b Get "http://localhost:9191": read tcp 127.0.0.1:40218->127.0.0.1:9191: read: connection reset by peer
error request to service-b Get "http://localhost:9191": read tcp 127.0.0.1:40232->127.0.0.1:9191: read: connection reset by peer
error request to service-b Get "http://localhost:9191": read tcp 127.0.0.1:38508->127.0.0.1:9191: read: connection reset by peer

SUCCESS!
service-b called: Hello from service B

service-b listening on 127.0.0.1:8080
```
