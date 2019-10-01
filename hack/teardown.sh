#!/bin/bash
WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/.."

set -e

source "${WORKDIR}/config.sh"

echo "Deleting namespace"
export KUBECONFIG=$HOME/tmp/installtest/auth/kubeconfig
oc project default
oc delete project $NAMESPACE --wait=false

MACHINESET="cewong-cb8cp-hypershift-us-east-1a"

echo "Scaling down worker machineset"
oc patch machineset "${MACHINESET}" -n openshift-machine-api --type=json -p '[{"op": "replace", "path": "/spec/replicas", value: 0}]'
