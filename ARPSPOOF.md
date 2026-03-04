# ARPSPOOF

## Why are we doing this?

In a service mesh like Consul Connect, traffic between services (e.g., `service-a` and `service-b`) is encrypted using mTLS by their sidecar proxies. If you just attach a network troubleshooting container to the same network, you will only see the traffic flowing but might remain unsure if the payload itself is actually secure.

To prove that the traffic is fully encrypted on the wire, we use ARP spoofing to simulate a Man-in-the-Middle (MITM) attack on our own cluster. By tricking `service-a` and `service-b` into routing their packets through our `netshoot` container first, we can intercept the raw network frames with `tcpdump` and inspect the payload. If we successfully intercept the traffic but only see binary gibberish instead of readable HTTP requests, we have definitively proven that our mTLS encryption is working as intended!

## Setup Guide

If you want to try ARP spoofing using the netshoot container,
here's how you could set it up (this requires adding NET_ADMIN privileges):

Update docker-compose:

```yaml
netshoot:
  build:
    context: .
    dockerfile: Dockerfile.netshoot
  container_name: netshoot
  command: sleep infinity
  cap_add:
    - NET_ADMIN
  networks:
    - mesh
```

Re-create netshoot:

```bash
docker compose up -d netshoot
```

Get the IPs of service-a and service-b

```bash
(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' service-a)
(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' service-b)
```

Exec into netshoot and run:

```bash
docker compose exec netshoot python3 /usr/local/bin/arpspoof 10.0.0.7 10.0.0.8
```

In another terminal on netshoot, capture traffic:

```bash
docker compose exec netshoot tcpdump -i eth0 -A host 10.0.0.7 and host 10.0.0.8
```
