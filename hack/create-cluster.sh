#!/bin/bash

WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/.."

set -e

source ${WORKDIR}/config.sh

export KUBECONFIG=${HOME}/tmp/installtest/auth/kubeconfig

rm -rf "${WORKDIR}/{manifests,pki}"

/bin/bash -e "${WORKDIR}/render-manifests.sh"

cd "${WORKDIR}/ignition-generator"

./make-ignition.sh

aws s3 cp "${WORKDIR}/ignition-generator/final.ign" s3://cewong-dev/final.ign --acl public-read

cd "${WORKDIR}"

oc new-project $NAMESPACE

oc apply -f "${WORKDIR}/manifests/managed"
