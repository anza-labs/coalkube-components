# coalkube-components

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
