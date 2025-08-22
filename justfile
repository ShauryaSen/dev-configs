set unstable

DIR := if os() == "macos" { "mac" } else { "linux" }
PWD := absolute_path(".")

# Display this help
default:
  @just --list --unsorted

# Create symlinks from $HOME to dotfiles in this repo
create-symlinks:
  echo "Creating symlinks from $HOME to dotfiles in this repo"
  # zsh
  mv -f "$HOME/.zshrc" "$HOME/.zshrc.bak"
  ln -sf "{{PWD}}/{{DIR}}/.zshrc" "$HOME/.zshrc"

  # bash
  mv -f "$HOME/.bashrc" "$HOME/.bashrc.bak"
  ln -sf "{{PWD}}/{{DIR}}/.bashrc" "$HOME/.bashrc"

  # tmux
  mv -f "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
  ln -sf "{{PWD}}/{{DIR}}/.tmux.conf" "$HOME/.tmux.conf"

  # nushell
  mv -f "$HOME/.config/nushell/config.nu" "$HOME/.config/nushell/config.nu.bak"
  ln -sf "{{PWD}}/{{DIR}}/config.nu" "$HOME/.config/nushell/config.nu"

  # jj
  ln -sf "{{PWD}}/common/jj-config.toml" "$HOME/.config/jj/config.toml"

  # git
  mv -f "$HOME/.gitconfig" "$HOME/.gitconfig.bak"
  ln -sf "{{PWD}}/{{DIR}}/.gitconfig" "$HOME/.gitconfig"
  mv -f "$HOME/.gitignore_global" "$HOME/.gitignore_global.bak"
  ln -sf "{{PWD}}/{{DIR}}/.gitignore_global" "$HOME/.gitignore_global"

  # neovim
  ln -sf "{{PWD}}/nvim" "$HOME/.config/nvim"

  # tmux-powerline
  ln -sf "{{PWD}}/{{DIR}}/tmux-powerline" "$HOME/.tmux/plugins"
  ln -sf "{{PWD}}/{{DIR}}/tmux-powerline/config.sh" "$HOME/.config/tmux-powerline/config.sh"

  # wezterm
  mkdir -p ~/.config/wezterm
  ln -sf "{{PWD}}/wez/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"

  # zellij
  mkdir -p ~/.config/zellij
  ln -sf "{{PWD}}/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"


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
