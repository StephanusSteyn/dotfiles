#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}➜${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only"
    exit 1
fi

print_info "Starting dotfiles installation..."
echo

# Get the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
print_info "Dotfiles directory: $DOTFILES_DIR"
echo

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
fi

echo

# Install required packages
print_info "Installing required packages..."
PACKAGES=(
    "zsh"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "zoxide"
    "eza"
    "pyenv"
    "xz"
)

for package in "${PACKAGES[@]}"; do
    if brew list "$package" &> /dev/null; then
        print_success "$package already installed"
    else
        print_info "Installing $package..."
        brew install "$package"
        print_success "$package installed"
    fi
done

echo

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
else
    print_success "Oh My Zsh already installed"
fi

echo

# Install Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    print_info "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    print_success "Powerlevel10k installed"
else
    print_success "Powerlevel10k already installed"
fi

echo

# Create symbolic links
print_info "Creating symbolic links..."

# Backup existing .zshrc if it exists and is not a symlink
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    print_info "Backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Create symlink for .zshrc
if [ -L "$HOME/.zshrc" ]; then
    rm "$HOME/.zshrc"
fi
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
print_success "Linked .zshrc"

# Create symlink for .config
if [ -L "$HOME/.config" ]; then
    print_info "Removing existing .config symlink"
    rm "$HOME/.config"
    ln -sf "$DOTFILES_DIR/.config" "$HOME/.config"
    print_success "Linked .config"
elif [ -d "$HOME/.config" ]; then
    print_info ".config directory exists. Linking nvim only..."
    ln -sf "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
    print_success "Linked .config/nvim"
else
    ln -sf "$DOTFILES_DIR/.config" "$HOME/.config"
    print_success "Linked .config"
fi

echo

# Optional: Install Neovim
read -p "Do you want to install Neovim with LSP support? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if brew list neovim &> /dev/null; then
        print_success "Neovim already installed"
    else
        print_info "Installing Neovim..."
        brew install neovim
        print_success "Neovim installed"
    fi
    print_info "Launch nvim to install plugins automatically"
fi

echo
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo
print_info "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Configure Powerlevel10k: p10k configure"
echo "  3. Install Python version: pyenv install 3.11.5 && pyenv global 3.11.5"
echo "  4. Update database aliases in .zshrc (lines 117-125) if needed"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "  5. Launch nvim to install plugins"
fi
echo
