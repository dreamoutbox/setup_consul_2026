package main

import (
	"io"
	"log"
	"net/http"
	"time"
)

func main() {
	log.Println("Start service-a")

	// Dial the local Consul Connect sidecar upstream port.
	// This is plain HTTP — no TLS code here at all.
	// The sidecar intercepts this, wraps it in mTLS, and forwards
	// it to service-b's sidecar on the other side.
	for {
		resp, err := http.Get("http://localhost:9002")
		if err != nil {
			log.Println("ERROR! service-a request to service-b", err)
		} else {
			body, _ := io.ReadAll(resp.Body)
			log.Println("SUCCESS! service-b called:", string(body))

			resp.Body.Close()
		}

		time.Sleep(time.Second * 1)
	}
}
