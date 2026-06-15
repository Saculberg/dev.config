#!/usr/bin/env bash

install_package ()
{
    local PACKAGE=$1
    local -n REPOS=$2
    echo "Determining package manager for $PACKAGE"

    for manager in "${!REPOS[@]}"; do
        if command -v "$manager" >/dev/null 2>&1; then
            echo "Using $manager"

            sudo bash -c "${REPOS[$manager]}"
            RC=$?

            if [[ $RC -ne 0 ]]; then
                echo "Failed to install $PACKAGE"
                exit 1
            fi
            return 0
        fi
    done

    echo "No supported package manager found for $PACKAGE"
    return 1
}

add_path ()
{
    local rcs=("$HOME/.bashrc" "$HOME/.zshrc")
    local FOLDER=$1
    export PATH="$PATH:$FOLDER"
    for i in "${rcs[@]}"; do
        if [[ -f "$i" ]]; then
            if ! grep -q "PATH=\"\$PATH:$FOLDER\"" "$i"; then
                echo "export PATH=\"\$PATH:$FOLDER\"" >> "$i"
            fi
        fi
    done
}

add_rc ()
{
    local rcs=("$HOME/.bashrc" "$HOME/.zshrc")
    local LINE=$1
    for i in "${rcs[@]}"; do
        if [[ -f "$i" ]]; then
            if ! grep -q "$LINE" "$i"; then
                echo "$LINE" >> "$i"
            fi
        fi
    done
}

versionlt() {
    [ "$1" = "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1)" ] && [ "$1" != "$2" ]
}

echo "Using git to download repo"

if ! command -v git >/dev/null 2>&1; then
    echo "git is not installed. Installing..."

    # Am i gonna check if this works? God no...
    declare -A GIT_REPOS
    GIT_REPOS[apt]="apt update && apt install -y git"
    GIT_REPOS[apt-get]="apt-get update && apt-get install -y git"
    GIT_REPOS[dnf]="dnf install -y git"
    GIT_REPOS[yum]="yum install -y git"
    GIT_REPOS[emerge]="emerge --ask --verbose dev-vcs/git"
    GIT_REPOS[pacman]="pacman -S --noconfirm git"
    GIT_REPOS[zypper]="zypper install -y git"
    GIT_REPOS[urpmi]="urpmi git"
    GIT_REPOS[nix-env]="nix-env -i git"
    GIT_REPOS[pkg]="pkg install -y developer/versioning/git"
    GIT_REPOS[pkgutil]="pkgutil -i git"
    GIT_REPOS[pkg_add]="pkg_add git"
    GIT_REPOS[apk]="apk add git"

    install_package "git" GIT_REPOS
fi

REPO_LOCATION="$HOME/dev.config"
REPO_URL="https://github.com/Saculberg/dev.config.git"

if [ -d "$REPO_LOCATION" ]; then
    echo "$REPO_LOCATION already exists. Updating..."

    git -C "$REPO_LOCATION" pull --ff-only
    RC=$?

    if [[ $RC -ne 0 ]]; then
        echo "Failed to update configuration from github"
        exit 1
    fi
else
    git clone "$REPO_URL" "$REPO_LOCATION"
    RC=$?

    if [[ $RC -ne 0 ]] || [[ ! -d "$REPO_LOCATION" ]]; then
        echo "Failed to checkout configuration from github"
        exit 1
    fi
fi

echo "Setting up shell"

# ZSH Installation and Shell Setup
if ! command -v zsh >/dev/null 2>&1; then
    echo "installing zsh"
    declare -A ZSH_REPOS
    ZSH_REPOS[apt]="apt update && apt install -y zsh"
    ZSH_REPOS[apt-get]="apt-get update && apt-get install -y zsh"
    ZSH_REPOS[dnf]="dnf install -y zsh"
    ZSH_REPOS[yum]="yum install -y zsh"
    ZSH_REPOS[pacman]="pacman -S --noconfirm zsh"
    ZSH_REPOS[brew]="brew install zsh"
    install_package "zsh" ZSH_REPOS
fi

ZSH=""
if command -v chsh >/dev/null 2>&1; then
    echo "Setting shell to zsh"
    sudo chsh -s "$(command -v zsh)" "$USER"
    ZSH="true"
    if [[ ! -f "$HOME/.zshrc" ]]; then
        echo "HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000
unsetopt autocd beep
bindkey -v" > "$HOME/.zshrc"
    fi
else
    echo "missing chsh, now switching to zsh"
    ZSH="false"
fi

echo "Making shell pretty"

if ! command -v oh-my-posh >/dev/null 2>&1; then
    echo "Installing ohmyposh"
    curl -s https://ohmyposh.dev/install.sh | bash -s
    add_path "$HOME/.local/bin"
fi

ln -sf "$REPO_LOCATION/.ohmyposh.json" "$HOME/.ohmyposh.json"

add_rc "eval \"\$(oh-my-posh init zsh --config ~/.ohmyposh.json)\""

# fzf installation
if ! command -v fzf >/dev/null 2>&1; then
    echo "installing fzf"
    declare -A FZF_REPOS
    FZF_REPOS[apt]="apt update && apt install -y fzf"
    FZF_REPOS[apk]="apk add fzf"
    FZF_REPOS[dnf]="dnf install -y fzf"
    FZF_REPOS[conda]="conda install -y -c conda-forge fzf"
    FZF_REPOS[nix-env]="nix-env -iA nixpkgs.fzf"
    FZF_REPOS[pacman]="pacman -S --noconfirm fzf"
    FZF_REPOS[pkg]="pkg install -y fzf"
    FZF_REPOS[pkgin]="pkgin install fzf"
    FZF_REPOS[pkg_add]="pkg_add fzf"
    install_package "fzf" FZF_REPOS
fi

if [[ -f "$HOME/.zshrc" ]] && ! grep -q "source <(fzf --zsh)" "$HOME/.zshrc"; then
    echo "source <(fzf --zsh)" >> "$HOME/.zshrc"
fi

if [[ -f "$HOME/.bashrc" ]] && ! grep -q "source <(fzf --bash)" "$HOME/.bashrc"; then
    echo "source <(fzf --bash)" >> "$HOME/.bashrc"
fi

if [[ "$ZSH" == "true" ]]; then
    echo "installing ohmyzsh"
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    for plugin in git docker; do
        if grep -qE "^plugins=\(.*\b${plugin}\b.*\)" "$HOME/.zshrc"; then
            continue
        elif grep -qE "^plugins=\(" "$HOME/.zshrc"; then
            sed -i -E "s/^plugins=\(([^)]*)\)/plugins=(\1 ${plugin})/" "$HOME/.zshrc"
        else
            echo "plugins=(${plugin})" >> "$HOME/.zshrc"
        fi
    done
fi

echo "Setting up nvim"

if ! command -v nvim >/dev/null 2>&1; then
    echo "nvim is not installed. Installing..."

    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

    rm -f nvim-linux-x86_64.tar.gz >/dev/null 2>&1 || true

    add_path "/opt/nvim-linux-x86_64/bin"
fi

echo "checking nvim version"

NVIM_VERSION=$(nvim --version | head -n1 | grep -o 'v[0-9][0-9.]*[0-9]')
NVIM_TARGET_VERSION="v0.12.2"

if versionlt "$NVIM_VERSION" "$NVIM_TARGET_VERSION"; then
    echo "nvim at $NVIM_VERSION, at least $NVIM_TARGET_VERSION required"
    exit 1
fi

mkdir -p "$HOME/.config" >/dev/null 2>&1

rm -rf "$HOME/.config/nvim" >/dev/null 2>&1
ln -sf "$REPO_LOCATION/nvim" "$HOME/.config/nvim"

echo "installing nvim deps"

if ! command -v make >/dev/null 2>&1; then
    echo "installing make"
    declare -A MAKE_REPOS
    MAKE_REPOS[apt]="apt update && apt install -y make"
    MAKE_REPOS[apt-get]="apt-get update && apt-get install -y make"
    MAKE_REPOS[dnf]="dnf install -y make"
    MAKE_REPOS[yum]="yum install -y make"
    MAKE_REPOS[pacman]="pacman -S --noconfirm make"
    MAKE_REPOS[apk]="apk add make"
    MAKE_REPOS[zypper]="zypper install -y make"
    MAKE_REPOS[brew]="brew install make"
    install_package "make" MAKE_REPOS
fi

if ! command -v go >/dev/null 2>&1; then
    echo "installing go"
    GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n1 | tr -d '[:space:]')
    curl -LO "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "${GO_VERSION}.linux-amd64.tar.gz"
    rm -f "${GO_VERSION}.linux-amd64.tar.gz"
    add_path "/usr/local/go/bin"
fi

if ! command -v lazygit >/dev/null 2>&1; then
    echo "installing lazygit"
    declare -A LAZYGIT_REPOS
    LAZYGIT_REPOS[apt]="apt update && apt install -y lazygit"
    LAZYGIT_REPOS[dnf]="dnf install -y lazygit"
    LAZYGIT_REPOS[yum]="yum install -y lazygit"
    LAZYGIT_REPOS[pacman]="pacman -S --noconfirm lazygit"
    LAZYGIT_REPOS[brew]="brew install jesseduffield/lazygit/lazygit"
    install_package "lazygit" LAZYGIT_REPOS
fi

echo "syncing nvim lazy plugins"
nvim --headless "+Lazy! sync" +qa

echo "setting up tmux"
if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux is not installed. Installing..."
    declare -A TMUX_REPOS
    TMUX_REPOS[apt]="apt update && apt install -y tmux"
    TMUX_REPOS[apt-get]="apt-get update && apt-get install -y tmux"
    TMUX_REPOS[dnf]="dnf install -y tmux"
    TMUX_REPOS[yum]="yum install -y tmux"
    TMUX_REPOS[pacman]="pacman -S --noconfirm tmux"
    install_package "tmux" TMUX_REPOS
fi

echo "Linking tmux configuration"
rm -rf "$HOME/.tmux.conf" >/dev/null 2>&1 || true
ln -sf "$REPO_LOCATION/.tmux.conf" "$HOME/.tmux.conf"
