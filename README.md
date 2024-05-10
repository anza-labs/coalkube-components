# coalkube-components

## Makefile Targets

The Makefile includes the following targets:

- **all**: Builds Docker images for all components.
- **update**: Updates the versions of the components to the latest available by executing the `hack/update-versions.sh` script and reports the changes.
- **crun**: Builds a Docker image for the `crun` runtime.
- **containerd**: Builds a Docker image for the `containerd` runtime.
- **kine**: Builds a Docker image for the `kine` key-value store shim.
- **kubernetes/kubelet**: Builds a Docker image for the Kubernetes `kubelet` component.
- **kubernetes/kube-controller-manager**: Builds a Docker image for the Kubernetes `kube-controller-manager` component.
- **kubernetes/kube-apiserver**: Builds a Docker image for the Kubernetes `kube-apiserver` component.
- **kubernetes/kube-scheduler**: Builds a Docker image for the Kubernetes `kube-scheduler` component.

## Docker Images

Images for the built components can be found at the GitHub Container Registry:

- [ghcr.io/anza-labs/crun](https://github.com/orgs/anza-labs/packages/container/package/crun)
- [ghcr.io/anza-labs/containerd](https://github.com/orgs/anza-labs/packages/container/package/containerd)
- [ghcr.io/anza-labs/kine](https://github.com/orgs/anza-labs/packages/container/package/kine)
- [ghcr.io/anza-labs/kubelet](https://github.com/orgs/anza-labs/packages/container/package/kubelet)
- [ghcr.io/anza-labs/kube-controller-manager](https://github.com/orgs/anza-labs/packages/container/package/kube-controller-manager)
- [ghcr.io/anza-labs/kube-apiserver](https://github.com/orgs/anza-labs/packages/container/package/kube-apiserver)
- [ghcr.io/anza-labs/kube-scheduler](https://github.com/orgs/anza-labs/packages/container/package/kube-scheduler)
- [ghcr.io/anza-labs/kube-proxy](https://github.com/orgs/anza-labs/packages/container/package/kube-proxy)

## Usage

To build all images, use the following command:

```sh
make all
```

### Building Images with Multiple Architectures

To create a new `docker buildx` builder for multi-architecture builds, use the following command:

```sh
docker buildx create --name multiarch --bootstrap --use
```

You can then build images for multiple architectures (e.g., `linux/arm64`, `linux/riscv64`, `linux/amd64`):

```sh
make crun \
    PLATFORM=linux/arm64,linux/riscv64,linux/amd64 \
    ENGINE='docker buildx'
```
