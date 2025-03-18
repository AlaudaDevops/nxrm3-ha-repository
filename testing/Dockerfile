FROM docker-mirrors.alauda.cn/library/golang:1.23.3-bookworm AS builder

WORKDIR /tools
RUN mkdir -p /tools/bin

ARG YQ_VERSION=4.25.2
ARG KUBECTL_VERSION=1.28.2
ARG HELM_VERSION=3.12.3
ARG DOCKER_VERSION=26.0.2

RUN set -eux; \
    if [ "$(arch)" = "arm64" ] || [ "$(arch)" = "aarch64" ]; then \
    export ARCH="arm64"; \
    export ARCH_ALIAS="arm64"; \
    else \
    export ARCH="amd64"; \
    export ARCH_ALIAS="x86_64"; \
    fi; \
    mkdir -p tmp; \
    curl -fsSLO https://download.docker.com/linux/static/stable/$(arch)/docker-${DOCKER_VERSION}.tgz && \
    tar xzvf docker-${DOCKER_VERSION}.tgz --strip 1 -C ./bin docker/docker && \
    curl -sfL https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${ARCH} -o ./bin/yq && \
    curl -sfL https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl -o ./bin/kubectl && \
    curl -sfL https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz | tar xzf - -C tmp 2>&1 && mv tmp/linux-${ARCH}/helm ./bin && \
    chmod +x ./bin/* && \
    rm -rf tmp && \
    ./bin/yq --version && \
    ./bin/kubectl version --client && \
    ./bin/helm version


COPY testing /app

FROM build-harbor.alauda.cn/ops/ubuntu:24.04

RUN mkdir -p /tools/bin
COPY --from=builder /tools/bin /tools/bin
COPY . /app

WORKDIR /app/testing
ENV PATH=/tools/bin:$PATH
ENV CI=true
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8
ENV TEST_COMMAND="nexus.test"

ENTRYPOINT ["nexus.test"]
CMD ["--godog.concurrency=2", "--godog.format=allure", "--godog.tags=~@e2e"]