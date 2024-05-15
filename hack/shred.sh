#!/usr/bin/env -S bash

set -eux
set -o pipefail

rm -rf tmp/

mkdir -p tmp/{base,outputs}

docker save "${1}" -o tmp/image.tar

tar -xf tmp/image.tar -C tmp/base

tar -xf "tmp/base/$(jq -r '.[0].Layers[0]' < tmp/base/manifest.json)" -C tmp/outputs
