_VERSIONS := $(shell bash -c "cat .versions.env | sed 's/=/ := /' | sed 's/^/export /' > versions.mk")
include versions.mk

REPOSITORY ?= ghcr.io/anza-labs
ENGINE ?= docker
ENGINE_ARGS ?=
PLATFORM ?= linux/$(shell arch)

.PHONY: all
all: crun containerd kine metrics-server \
	kubernetes/kubelet kubernetes/kube-controller-manager kubernetes/kube-apiserver \
	kubernetes/kube-scheduler kubernetes/kube-proxy

update:
	@./hack/update-versions.sh
	@./hack/update-maintainers.sh

containerd:
	$(ENGINE) build \
		--platform=$(PLATFORM) \
		--tag=$(REPOSITORY)/containerd:$(CONTAINERD) \
		--build-arg=VERSION=$(CONTAINERD) \
		$(ENGINE_ARGS) \
		./containers/containerd

crun:
	$(ENGINE) build \
		--platform=$(PLATFORM) \
		--tag=$(REPOSITORY)/crun:$(CRUN) \
		--build-arg=VERSION=$(CRUN) \
		$(ENGINE_ARGS) \
		./containers/crun

kine:
	$(ENGINE) build \
		--platform=$(PLATFORM) \
		--tag=$(REPOSITORY)/kine:$(KINE) \
		--build-arg=VERSION=$(KINE) \
		$(ENGINE_ARGS) \
		./containers/kine

metrics-server:
	$(ENGINE) build \
		--platform=$(PLATFORM) \
		--tag=$(REPOSITORY)/metrics-server:$(METRICS_SERVER) \
		--build-arg=VERSION=$(METRICS_SERVER) \
		$(ENGINE_ARGS) \
		./containers/metrics-server

kubernetes/%:
	$(ENGINE) build \
		--platform=$(PLATFORM) \
		--tag=$(REPOSITORY)/$*:$(KUBERNETES) \
		--build-arg=BIN=$* \
		--build-arg=VERSION=$(KUBERNETES) \
		$(ENGINE_ARGS) \
		./containers/kubernetes
