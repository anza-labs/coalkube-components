#!/usr/bin/env -S bash

set -eux
set -o pipefail

# Determine the appropriate `sed` command based on the operating system
if [[ "$(uname)" == "Darwin" ]]; then
    # If the operating system is Darwin (macOS), use `gsed`
    sed_command="gsed"
else
    # Otherwise, use `sed`
    sed_command="sed"
fi

function getver() {
    curl -fsSL "https://api.github.com/repos/${1}/releases/latest" | jq -r '.tag_name'
}

function extract_current_tag() {
    local tag_name="${1}"
    local source_file="${2}"
    grep "${tag_name}" "${source_file}" | "${sed_command}" -E "s/.*'(.*)'/\1/"
}

function submodule_update() {(
    local location="${1}"
    local version="${2}"
    git submodule update --init --depth=1 "${location}"
    cd "${location}"
    git fetch origin "${version}"
    git checkout "$(git ls-remote origin | grep "${version}\$" | awk '{print $1}')"
)}

echo -n "" > .versions.env

current_kine_tag="$(extract_current_tag '&kine_tag' './.woodpecker/kine.yaml')"
kine_tag="$(getver k3s-io/kine)"
echo "KINE=${kine_tag}" >> .versions.env
"${sed_command}" -i "s/'${current_kine_tag}'/\'${kine_tag}\'/g" './.woodpecker/kine.yaml'
submodule_update ./containers/kine/src "${kine_tag}"

current_kubernetes_tag="$(extract_current_tag '&kubernetes_tag' './.woodpecker/kube.yaml')"
kubernetes_tag="$(getver kubernetes/kubernetes)"
echo "KUBERNETES=${kubernetes_tag}" >> .versions.env
"${sed_command}" -i "s/'${current_kubernetes_tag}'/\'${kubernetes_tag}\'/g" './.woodpecker/kube.yaml'
submodule_update ./containers/kubernetes/src "${kubernetes_tag}"

current_metrics_server_tag="$(extract_current_tag '&metrics_server_tag' './.woodpecker/metrics-server.yaml')"
metrics_server_tag="$(getver kubernetes-sigs/metrics-server)"
echo "METRICS_SERVER=${metrics_server_tag}" >> .versions.env
"${sed_command}" -i "s/'${current_metrics_server_tag}'/\'${metrics_server_tag}\'/g" './.woodpecker/metrics-server.yaml'
submodule_update ./containers/metrics-server/src "${metrics_server_tag}"
