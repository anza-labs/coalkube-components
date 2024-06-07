#!/usr/bin/env bash
set -eu

DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
VERSION="${1}"

# yanked from Kubernetes build tools
if [[ "${VERSION}" =~ ^v([0-9]+)\.([0-9]+)(\.[0-9]+)?([-].*)?([+].*)?$ ]]; then
  VERSION_MAJOR=${BASH_REMATCH[1]}
  VERSION_MINOR=${BASH_REMATCH[2]}
  if [[ -n "${BASH_REMATCH[4]}" ]]; then
    VERSION_MINOR+="+"
  fi
fi

echo "-s -w -extldflags=-static"
echo "-X k8s.io/client-go/pkg/version.buildDate=${DATE}"
echo "-X k8s.io/component-base/version.buildDate=${DATE}"
echo "-X k8s.io/client-go/pkg/version.gitCommit=HEAD"
echo "-X k8s.io/component-base/version.gitCommit=HEAD"
echo "-X k8s.io/client-go/pkg/version.gitVersion=${VERSION}"
echo "-X k8s.io/component-base/version.gitVersion=${VERSION}"
echo "-X k8s.io/client-go/pkg/version.gitMajor=${VERSION_MAJOR}"
echo "-X k8s.io/component-base/version.gitMajor=${VERSION_MAJOR}"
echo "-X k8s.io/client-go/pkg/version.gitMinor=${VERSION_MINOR}"
echo "-X k8s.io/component-base/version.gitMinor=${VERSION_MINOR}"
echo "-X k8s.io/client-go/pkg/version.gitTreeState=clean"
echo "-X k8s.io/component-base/version.gitTreeState=clean"
