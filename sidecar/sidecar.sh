#!/bin/sh

export SIDECAR_NAME=$1

while true; do
    echo "========================================================="
    echo "[$SIDECAR_NAME] discovering healthy Consul server...";
    echo "========================================================="

    CONSUL_ADDR='';
    while [ -z "$CONSUL_ADDR" ]; do
        for addr in consul1:8500 consul2:8500 consul3:8500 consul4:8500 consul5:8500; do
            if wget -T 2 -qO- http://$addr/v1/agent/services 2>/dev/null | grep -q "${SIDECAR_NAME}-sidecar-proxy"; then
            CONSUL_ADDR=$addr;
            break;
            fi;
        done;

        [ -z "$CONSUL_ADDR" ] && sleep 1;
    done;

    echo "========================================================="
    echo "[$SIDECAR_NAME] Using Consul at $CONSUL_ADDR";
    echo "========================================================="
    export CONSUL_HTTP_ADDR=$CONSUL_ADDR;

    consul connect proxy -sidecar-for $SIDECAR_NAME -log-level warn &
    PROXY_PID=$!;

    while kill -0 $PROXY_PID 2>/dev/null; do
        if ! wget -T 1 -qO- http://$CONSUL_ADDR/v1/status/leader 2>/dev/null | grep -q '.' ; then
            echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            echo "[$SIDECAR_NAME] Consul at $CONSUL_ADDR unreachable, killing proxy...";
            echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

            kill $PROXY_PID 2>/dev/null;
            wait $PROXY_PID 2>/dev/null;
            break;
        fi;
        sleep 3;
    done;

    echo "[$SIDECAR_NAME] proxy exited, restarting...";
    sleep 1;
done
