package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "Hello from service B")
	})

	fmt.Println("service-b listening on 127.0.0.1:8080")

	// after (loopback only — the sidecar is the only way in)
	http.ListenAndServe("127.0.0.1:8080", nil)
}
