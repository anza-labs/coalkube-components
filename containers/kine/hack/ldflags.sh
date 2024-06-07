#!/usr/bin/env bash
set -eu

VERSION="${1}"

echo "-s -w -extldflags=-static"
echo "-X github.com/k3s-io/kine/pkg/version.Version=${VERSION}"
