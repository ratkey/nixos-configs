{ pkgs, ... }:
let
  installLazyVim = pkgs.writeShellScriptBin "install-lazyvim" ''
    #!/usr/bin/env bash
    
    NVIM_CONFIG="$HOME/.config/nvim"
    
    if [ -d "$NVIM_CONFIG" ]; then
      BACKUP_DIR="$NVIM_CONFIG.bak.$(date +%Y%m%d_%H%M%S)"
      echo "Backing up existing nvim config to $BACKUP_DIR..."
      mv "$NVIM_CONFIG" "$BACKUP_DIR"
    fi

    echo "Cloning LazyVim starter..."
    git clone https://github.com/LazyVim/starter "$NVIM_CONFIG"

    # Remove the .git folder so you can add it to your own repo later
    rm -rf "$NVIM_CONFIG/.git"

    echo "LazyVim installed! Run 'nvim' to start."
  '';
in
{
  home.packages = with pkgs; [
    installLazyVim
    
    # Core tools often needed by LazyVim/Mason external to nvim wrapper
    ripgrep
    fd
    gcc
    unzip
    wget
    curl
    tree-sitter
    xclip
    wl-clipboard
    nodejs_22
    python3
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # Tools strictly for Neovim's internal wrapper
    extraPackages = with pkgs; [
      lua-language-server
      nixd
      stylua
      black
      nixpkgs-fmt
    ];
  };
}