package main

import (
	"fmt"
	"io"
	"net/http"
	"time"
)

func main() {
	fmt.Println("Start service-a")

	// Dial the local Consul Connect sidecar upstream port.
	// This is plain HTTP — no TLS code here at all.
	// The sidecar intercepts this, wraps it in mTLS, and forwards
	// it to service-b's sidecar on the other side.
	for i := 0; i < 10; i++ {
		resp, err := http.Get("http://localhost:9191")
		if err != nil {
			fmt.Println("error request to service-b", err)
			time.Sleep(time.Second * 2)
			continue
		}
		defer resp.Body.Close()

		body, _ := io.ReadAll(resp.Body)
		fmt.Println("\nSUCCESS!\nservice-b called:", string(body))

		break
	}
}
