# Use the official Golang Image
FROM golang:bookworm

RUN apt-get update && \
    apt-get install -y \
                    jq \
                    yq

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN az aks install-cli

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh

RUN rm get_helm.sh

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v1.30.2/bin/linux/$(uname -m)/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Install docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh