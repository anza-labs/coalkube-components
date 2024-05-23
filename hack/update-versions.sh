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

function getdefault() {
    curl -fsSL "https://api.github.com/repos/${1}" | jq -r '.default_branch'
}

function extract_current_tag() {
    local tag_name="${1}"
    local source_file="${2}"
    grep "${tag_name}" "${source_file}" | "${sed_command}" -E "s/.*'(.*)'/\1/"
}

function submodule_update() {(
    local location="${1}"
    local kind="${2}"
    local version="${3}"
    git submodule update --init --depth=1 "${location}"
    cd "${location}"
    git fetch origin "${version}"
    git checkout "${kind}/${version}"
)}

echo -n "" > .versions.env

current_containerd_tag="$(extract_current_tag '&containerd_tag' './.woodpecker/containerd.yaml')"
containerd_tag="$(getver containerd/containerd)"
containerd_tag="${containerd_tag#v}"
echo "CONTAINERD=${containerd_tag}" >> .versions.env
"${sed_command}" -i "s/'${current_containerd_tag}'/\'${containerd_tag}\'/g" './.woodpecker/containerd.yaml'

current_crun_tag="$(extract_current_tag '&crun_tag' './.woodpecker/crun.yaml')"
crun_tag="$(getver containers/crun)"
echo "CRUN=${crun_tag}" >> .versions.env
"${sed_command}" -i "s/'${current_crun_tag}'/\'${crun_tag}\'/g" './.woodpecker/crun.yaml'

current_kine_tag="$(extract_current_tag '&kine_tag' './.woodpecker/kine.yaml')"
kine_tag="$(getver k3s-io/kine)"
echo "KINE=${kine_tag}" >> .versions.env
"${sed_command}" -i "s/'${current_kine_tag}'/\'${kine_tag}\'/g" './.woodpecker/kine.yaml'
submodule_update ./containers/kine/src tags "${kine_tag}"

current_kubernetes_tag="$(extract_current_tag '&kubernetes_tag' './.woodpecker/kube.yaml')"
kubernetes_tag="$(getver kubernetes/kubernetes)"
echo "KUBERNETES=${kubernetes_tag}" >> .versions.env
"${sed_command}" -i "s/'${current_kubernetes_tag}'/\'${kubernetes_tag}\'/g" './.woodpecker/kube.yaml'
submodule_update ./containers/kubernetes/src tags "${kubernetes_tag}"

current_metrics_server_tag="$(extract_current_tag '&metrics_server_tag' './.woodpecker/metrics-server.yaml')"
metrics_server_tag="$(getver kubernetes-sigs/metrics-server)"
echo "METRICS_SERVER=${metrics_server_tag}" >> .versions.env
"${sed_command}" -i "s/'${current_metrics_server_tag}'/\'${metrics_server_tag}\'/g" './.woodpecker/metrics-server.yaml'
submodule_update ./containers/metrics-server/src tags "${metrics_server_tag}"

current_raspberrypi_linux_branch="$(extract_current_tag '&raspberrypi_linux_branch' './.woodpecker/linux-rpi-cm4.yaml')"
raspberrypi_linux_branch="$(getdefault raspberrypi/linux)"
echo "RASPBERRYPI_LINUX=${raspberrypi_linux_branch}" >> .versions.env
"${sed_command}" -i "s/'${current_raspberrypi_linux_branch}'/\'${raspberrypi_linux_branch}\'/g" './.woodpecker/linux-rpi-cm4.yaml'
submodule_update ./linux/raspberrypi-cm4/src origin "${raspberrypi_linux_branch}"

current_mars_cm_sd_linux_branch="$(extract_current_tag '&mars_cm_sd_linux_branch' './.woodpecker/linux-mars-cm-sd.yaml')"
mars_cm_sd_linux_branch="dev-mars-cm-sdcard" # NOTE: hardcoded branch
echo "MILKV_MARS_CM_SD_LINUX=${mars_cm_sd_linux_branch}" >> .versions.env
"${sed_command}" -i "s/'${current_mars_cm_sd_linux_branch}'/\'${mars_cm_sd_linux_branch}\'/g" './.woodpecker/linux-mars-cm-sd.yaml'
submodule_update ./linux/milkv-mars-cm-sdcard/src origin "${mars_cm_sd_linux_branch}"
