#!/usr/bin/env bash
set -x
ip addr delete 169.254.1.1/32 dev lo
ip route del 169.254.1.1/32 dev lo scope link src 169.254.1.1
