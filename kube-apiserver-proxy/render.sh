#!/bin/bash

set -eux

source ../lib/common.sh

cat > ../manifests/user/kube-apiserver-proxy-config.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-apiserver-proxy-config
  namespace: kube-system
data:
  haproxy.cfg: |-
    global
      maxconn 32000

    defaults
      mode tcp
      timeout client 30000ms
      timeout server 30000ms
      timeout connect 3000ms
      retries 3

    frontend local_apiserver
      bind 169.254.1.1:6443
      default_backend remote_apiserver

    backend remote_apiserver
      server ${EXTERNAL_API_DNS_NAME}:${EXTERNAL_API_PORT}
EOF

cp kube-apiserver-proxy-daemonset.yaml ../manifests/user
