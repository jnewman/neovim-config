FROM debian:bookworm-slim

ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive
# Aggregate PATH for all tool installs; set once so docker exec inherits it
ENV PATH=/root/.cargo/bin:/root/.ghcup/bin:/root/.cabal/bin:/root/.local/share/coursier/bin:/usr/local/go/bin:/root/go/bin:$PATH

# ── Base system ──────────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget unzip git ca-certificates xz-utils \
    build-essential \
    clang clang-format \
    libxml2-utils \
    ruby-full ruby-dev \
    python3 python3-pip \
    libncurses-dev \
    default-jre-headless \
    && rm -rf /var/lib/apt/lists/*

# ── Node.js 20 + npm LSPs ─────────────────────────────────────────────────────
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g --omit=optional \
    pyright \
    typescript-language-server \
    typescript \
    bash-language-server \
    vscode-langservers-extracted \
    prettier

# ── Go + gopls + shfmt ───────────────────────────────────────────────────────
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) GOARCH=amd64 ;; \
      arm64) GOARCH=arm64 ;; \
      *) echo "Unsupported arch: $TARGETARCH"; exit 1 ;; \
    esac; \
    curl -fsSL "https://go.dev/dl/go1.23.0.linux-${GOARCH}.tar.gz" -o /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

RUN go install golang.org/x/tools/gopls@latest \
    && go install mvdan.cc/sh/v3/cmd/shfmt@latest

# ── Rust + rust-analyzer + rustfmt ───────────────────────────────────────────
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain stable --no-modify-path \
    && rustup component add rust-analyzer rustfmt

# ── Python: ruff ─────────────────────────────────────────────────────────────
RUN pip3 install --break-system-packages ruff

# ── Ruby: ruby-lsp + rubocop ─────────────────────────────────────────────────
RUN gem install ruby-lsp rubocop --no-document

# ── Scala: Coursier → metals + scalafmt ──────────────────────────────────────
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) CS_ARCH=x86_64-pc-linux ;; \
      arm64) CS_ARCH=aarch64-pc-linux ;; \
    esac; \
    curl -fL "https://github.com/coursier/launchers/raw/master/cs-${CS_ARCH}.gz" \
      | gzip -d > /usr/local/bin/cs \
    && chmod +x /usr/local/bin/cs \
    && cs setup --yes \
    && cs install metals scalafmt

# ── Haskell: GHCup → HLS + ormolu ────────────────────────────────────────────
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org \
    | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
      BOOTSTRAP_HASKELL_GHC_VERSION=recommended \
      BOOTSTRAP_HASKELL_INSTALL_HLS=1 \
      sh \
    && cabal update \
    && cabal install ormolu --overwrite-policy=always

# ── Terraform + terraform-ls ──────────────────────────────────────────────────
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) TF_ARCH=amd64 ;; \
      arm64) TF_ARCH=arm64 ;; \
    esac; \
    TF_VERSION=1.9.0; \
    TF_LS_VERSION=0.34.0; \
    curl -fsSL "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_${TF_ARCH}.zip" \
      -o /tmp/terraform.zip \
    && unzip /tmp/terraform.zip terraform -d /usr/local/bin/ \
    && rm /tmp/terraform.zip; \
    curl -fsSL "https://releases.hashicorp.com/terraform-ls/${TF_LS_VERSION}/terraform-ls_${TF_LS_VERSION}_linux_${TF_ARCH}.zip" \
      -o /tmp/terraform-ls.zip \
    && unzip /tmp/terraform-ls.zip terraform-ls -d /usr/local/bin/ \
    && rm /tmp/terraform-ls.zip

# ── lemminx (XML LSP) ─────────────────────────────────────────────────────────
# Use the uber JAR (cross-platform; no native ARM64 Linux binary exists)
RUN mkdir -p /usr/local/lib \
    && curl -fsSL "https://download.eclipse.org/lemminx/releases/0.27.0/org.eclipse.lemminx-uber.jar" \
      -o /usr/local/lib/lemminx.jar \
    && printf '#!/bin/sh\nexec java -jar /usr/local/lib/lemminx.jar "$@"\n' \
      > /usr/local/bin/lemminx \
    && chmod +x /usr/local/bin/lemminx

CMD ["sleep", "infinity"]
