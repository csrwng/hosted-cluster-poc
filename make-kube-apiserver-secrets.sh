#!/bin/bash

set -eux

source ./common.sh

cat > kube-apiserver/kube-apiserver-secret.yaml <<EOF 
apiVersion: v1
kind: Secret
metadata:
  name: kube-apiserver
data:
  server.crt: $(encode pki/kube-apiserver-server.pem)
  server.key: $(encode pki/kube-apiserver-server-key.pem)
  kubelet-client.crt: $(encode pki/kube-apiserver-kubelet.pem)
  kubelet-client.key: $(encode pki/kube-apiserver-kubelet-key.pem)
  etcd-client.crt: $(encode pki/etcd-client.pem)
  etcd-client.key: $(encode pki/etcd-client-key.pem)
  ca.crt: $(encode pki/ca.pem)
  service-account.pub: $(encode pki/service-account.pem)
EOF
