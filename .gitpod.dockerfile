FROM gitpod/workspace-full
USER gitpod

LABEL maintainer="@k33g_org"

ARG WORKSPACE_ARCH=amd64
ARG GO_VERSION=1.21.3
ARG TINYGO_VERSION=0.30.0
ARG EXTISM_VERSION=0.3.3

# Update the system and install necessary tools
RUN <<EOF
sudo apt-get update 
sudo apt-get install -y curl wget git build-essential xz-utils bat exa software-properties-common 
sudo apt-get install -y clang lldb lld
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update 
sudo apt-get install -y python3.8
sudo ln -s /usr/bin/batcat /usr/bin/bat
EOF

# ------------------------------------
# Install Go
# ------------------------------------
RUN <<EOF
GO_ARCH="${WORKSPACE_ARCH}"

wget https://golang.org/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz
tar -xvf go${GO_VERSION}.linux-${GO_ARCH}.tar.gz
sudo mv go /usr/local
EOF

# ------------------------------------
# Set Environment Variables for Go
# ------------------------------------
ENV GOROOT=/usr/local/go
ENV GOPATH=$HOME/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

RUN <<EOF
go version
go install -v golang.org/x/tools/gopls@latest
go install -v github.com/ramya-rao-a/go-outline@latest
go install -v github.com/stamblerre/gocode@v1.0.0
go install -v github.com/mgechev/revive@v1.3.2
EOF

# ------------------------------------
# Install TinyGo
# ------------------------------------
RUN <<EOF
TINYGO_ARCH="${WORKSPACE_ARCH}"

wget https://github.com/tinygo-org/tinygo/releases/download/v${TINYGO_VERSION}/tinygo_${TINYGO_VERSION}_${TINYGO_ARCH}.deb
sudo dpkg -i tinygo_${TINYGO_VERSION}_${TINYGO_ARCH}.deb
rm tinygo_${TINYGO_VERSION}_${TINYGO_ARCH}.deb
EOF

# ------------------------------------
# Install Extism CLI
# ------------------------------------
RUN <<EOF
EXTISM_ARCH="${WORKSPACE_ARCH}"

wget https://github.com/extism/cli/releases/download/v${EXTISM_VERSION}/extism-v${EXTISM_VERSION}-linux-${EXTISM_ARCH}.tar.gz

sudo tar -xf extism-v${EXTISM_VERSION}-linux-${EXTISM_ARCH}.tar.gz -C /usr/bin
rm extism-v${EXTISM_VERSION}-linux-${EXTISM_ARCH}.tar.gz

extism --version
EOF

# Command to run when starting the container
CMD ["/bin/bash"]
