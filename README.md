# Dotfiles

A customized terminal environment for macOS featuring Zsh with Oh My Zsh, Powerlevel10k theme, and productivity enhancements.

## Features

- **Oh My Zsh** with Powerlevel10k theme for a fast, customizable prompt
- **Zsh plugins**: autosuggestions, syntax highlighting
- **Smart navigation**: zoxide for intelligent directory jumping
- **Enhanced file listing**: eza with git integration and icons
- **Python environment**: pyenv for version management
- **Database aliases**: Quick access to PostgreSQL instances
- **Claude Code**: Integrated into PATH
- **Neovim configuration** (optional): LSP and completions for heavy Neovim users

## Prerequisites

- macOS (Darwin)
- Terminal with true color support
- Administrative access for Homebrew installation

## Installation

### Automated Setup

Run the installation script to automatically configure everything:

```bash
git clone https://github.com/StephanusSteyn/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The script will:
1. Install Homebrew (if not present)
2. Install required packages and tools
3. Install Oh My Zsh and Powerlevel10k
4. Create symbolic links for configuration files
5. Optionally set up Neovim

### Manual Setup

If you prefer manual installation:

1. **Install Homebrew**:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install dependencies**:
   ```bash
   brew install zsh zsh-autosuggestions zsh-syntax-highlighting zoxide eza pyenv xz
   ```

3. **Install Oh My Zsh**:
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

4. **Install Powerlevel10k**:
   ```bash
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
   ```

5. **Create symbolic links**:
   ```bash
   ln -sf ~/dotfiles/.zshrc ~/.zshrc
   ln -sf ~/dotfiles/.config ~/.config
   ```

6. **Reload shell**:
   ```bash
   source ~/.zshrc
   ```

## Post-Installation

### Configure Powerlevel10k

On first launch, Powerlevel10k will prompt you to configure your theme:
```bash
p10k configure
```

### Configure Pyenv

Install your preferred Python version:
```bash
pyenv install 3.11.5
pyenv global 3.11.5
```

### Neovim Setup (Optional)

Only required if you plan to use Neovim extensively:

1. Install Neovim:
   ```bash
   brew install neovim
   ```

2. Launch Neovim to install plugins:
   ```bash
   nvim
   ```

The lazy.nvim plugin manager will automatically install configured plugins including LSP support.

## Customization

### Database Aliases

Update database connection aliases in `.zshrc` lines 117-125 to match your infrastructure.

### Additional Aliases

Add custom aliases to `.zshrc` or create separate files in `$ZSH_CUSTOM` directory.

## Structure

```
dotfiles/
├── .zshrc              # Zsh configuration
├── .config/
│   └── nvim/           # Neovim configuration (optional)
│       ├── init.lua
│       └── lua/
└── install.sh          # Automated installation script
```

## Maintenance

Update packages regularly:
```bash
brew update && brew upgrade
omz update
```

## License

MIT
