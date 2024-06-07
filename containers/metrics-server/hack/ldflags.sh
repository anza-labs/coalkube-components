#!/usr/bin/env bash
set -eu

DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
VERSION="${1}"

echo "-s -w -extldflags=-static"
echo "-X k8s.io/client-go/pkg/version.buildDate=${DATE}"
echo "-X k8s.io/client-go/pkg/version.gitCommit=HEAD"
echo "-X k8s.io/client-go/pkg/version.gitVersion=${VERSION}"
