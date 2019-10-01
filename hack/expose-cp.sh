#!/bin/bash

set -e

source ./config.sh

BASEDOMAIN=hive.openshift.com
CLUSTERDOMAIN="${NAMESPACE}.${BASEDOMAIN}"

ZONE_ID="$(aws route53 list-hosted-zones-by-name --dns-name "${BASEDOMAIN}" | jq -r '.HostedZones[0].Id')"
LB_ADDRESS="$(oc get service kube-apiserver -o jsonpath='{ .status.loadBalancer.ingress[0].hostname }')"
CHANGE_BATCH="$(cat << EOF | jq -c
{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "api.${CLUSTERDOMAIN}",
        "Type": "CNAME",
        "TTL": 30,
        "ResourceRecords": [
          {
            "Value": "${LB_ADDRESS}"
          }
        ]
      }
    }
  ]
}
EOF)"
aws route53 change-resource-record-sets --hosted-zone-id="${ZONE_ID}" --change-batch "${CHANGE_BATCH}"
