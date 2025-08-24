set unstable

DIR := if os() == "macos" { "mac" } else { "linux" }
PWD := absolute_path(".")

# Display this help
default:
  @just --list --unsorted

# Create symlinks from $HOME to dotfiles in this repo
setup:
  just wez/setup
  just zsh/setup
  just nvim/setup

# Install shell plugins
[script("zsh")]
setup-plugins:
  echo "Installing shell plugins"
  ZSH="${ZSH:-$HOME/.oh-my-zsh}"
  if [ ! -d "${ZSH}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH}/plugins/zsh-autosuggestions"
  else
    echo "zsh-autosuggestions already installed"
  fi

  if [ ! -d "${ZSH}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH}/plugins/zsh-syntax-highlighting"
  else
    echo "zsh-syntax-highlighting already installed"
  fi

  if [ ! -d "${ZSH}/plugins/zsh-vi-mode" ]; then
    git clone https://github.com/jeffreytse/zsh-vi-mode "${ZSH}/plugins/zsh-vi-mode"
  else
    echo "zsh-vi-mode already installed"
  fi

  if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  else
    echo "tmux plugin manager already installed"
  fi


# Build+install Rust tools
[macos]
install-rust-tools:
    cargo install --locked --bin jj jj-cli
    cargo install nu --locked
    cargo install fd-find
    cargo install just
    cargo install ripgrep
    cargo install --locked zellij
    brew install difftastic

# Build+install Rust tools
[linux]
install-rust-tools:
    cargo install --locked --bin jj jj-cli
    cargo install nu --locked
    cargo install fd-find
    cargo install just
    cargo install ripgrep
    cargo install --locked difftastic
    cargo install --locked zellij


# Install Language Servers
[macos]
install-language-servers:
  rustup component add rust-analyzer
  uv tool install --with rope --with pylsp-rope --with python-lsp-ruff --with pylsp-mypy python-lsp-server
  brew install lua-language-server

# Install Language Servers
[script("zsh")]
[linux]
install-language-servers:
  rustup component add rust-analyzer
  uv tool install --with rope --with pylsp-rope --with python-lsp-ruff --with pylsp-mypy python-lsp-server
  if ! command -v lua-language-server >/dev/null 2>&1; then
    if [ ! -d ~/lua-ls ]; then
      mkdir ~/lua-ls
      wget -P /tmp https://github.com/LuaLS/lua-language-server/releases/download/3.15.0/lua-language-server-3.15.0-linux-x64.tar.gz
      tar -xvzf /tmp/lua-language-server-3.15.0-linux-x64.tar.gz -C ~/lua-ls
    fi
    ln -sf ~/lua-ls/bin/lua-language-server ~/.local/bin
  else
    echo "lua-language-server already downloaded"
  fi



# Install Nerd Fonts
[macos]
install-nerd-fonts:
  brew install font-inconsolata-nerd-font
