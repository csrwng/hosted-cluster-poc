#!/bin/bash

set -eux

source ./common.sh

export CA=$(encode pki/ca.pem)
for secret in etcd-client server peer; do
    export SECRET=${secret}
    FILE=${SECRET}
    if [ "${FILE}" != "etcd-client" ]; then
        FILE="etcd-${SECRET}"
    fi
    export FILE
    
    export CRT=$(encode pki/${FILE}.pem)
    export KEY=$(encode pki/${FILE}-key.pem)
    envsubst < templates/etcd-secret-template.yaml > etcd/${FILE}-tls-secret.yaml
done
