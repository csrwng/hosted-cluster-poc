#!/usr/bin/env bash
set -x
ip addr add 169.254.1.1/32 brd 169.254.1.1 scope host dev lo
ip route add 169.254.1.1/32 dev lo scope link src 169.254.1.1
