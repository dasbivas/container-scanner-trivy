FROM alpine

ENV KUBE_LATEST_VERSION="v1.18.2"
ARG DOCKER_CLI_VERSION="19.03.8"

RUN apk add --no-cache ca-certificates bash git openssh curl tar nfs-utils jq diffutils \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && mkdir -p /tmp/download \
    && curl -L https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION.tgz | tar -xz -C /tmp/download \
    && wget https://github.com/optiopay/klar/releases/download/v2.4.0/klar-2.4.0-linux-amd64 -O /usr/local/bin/klar \
    && chmod +x /usr/local/bin/klar \
    && mv /tmp/download/docker/docker /usr/local/bin/ \
    && rm -rf /tmp/download \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /backup

RUN apk add curl \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin \
    && trivy filesystem --exit-code 1 --severity CRITICAL --no-progress /
        
CMD bash
