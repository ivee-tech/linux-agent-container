FROM ubuntu:20.04

ARG TARGETARCH=x64
ARG RUNNER_VERSION=2.298.2

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
# RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    libcurl4 \
    # libicu60 \
    libunwind8 \
    netcat \
    libssl1.0 \
    gnupg \
    lsb-release \
    wget \
    apt-transport-https \
    software-properties-common \
    sudo \
  && rm -rf /var/lib/apt/lists/*

# install .NETD SDK 6.0
RUN wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install -y dotnet-sdk-6.0

# install PowerShell
RUN wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install -y powershell

# install az CLI
RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

# # install kubectl
# RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
# RUN apt-get update
# RUN apt-get install -y kubectl

# install az aks CLIs (kubectl & kubelogin)
RUN az aks install-cli

# install azcopy
RUN wget -O azcopy.tar.gz https://aka.ms/downloadazcopy-v10-linux && tar -xf azcopy.tar.gz && cp ./azcopy_linux*/azcopy /usr/bin

WORKDIR /actions-runner

# Download the latest runner package
RUN curl -o actions-runner-linux-${TARGETARCH}-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${TARGETARCH}-${RUNNER_VERSION}.tar.gz
RUN echo https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${TARGETARCH}-${RUNNER_VERSION}.tar.gz
RUN tar -xf ./actions-runner-linux-${TARGETARCH}-${RUNNER_VERSION}.tar.gz

COPY ./start.sh .
RUN chmod +x start.sh

CMD [ "./start.sh" ]