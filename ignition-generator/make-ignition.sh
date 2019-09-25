#!/bin/bash

set -eux

source ../config.sh

echo "copying HAProxy config"
envsubst < ./apiserver-haproxy.cfg.template > fake-root/etc/haproxy/apiserver-haproxy.cfg

echo "copying PKI assets"
cp ../pki/kubelet-bootstrap.kubeconfig fake-root/etc/kubernetes/kubeconfig
# kubeconfig needs to be world readable because network-operator reads it for server URL
chmod +r fake-root/etc/kubernetes/kubeconfig
cp ../pki/root-ca.pem fake-root/etc/kubernetes/ca.crt
echo "transpiling files"
./filetranspile -i base.ign -f fake-root -o tmp.ign
echo "transpiling units"
./unittranspile -i tmp.ign -u units -o final.ign
rm -f tmp.ign
echo "Ignition file is ready in final.ign"
