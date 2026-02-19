{ pkgs, ... }:
{
  # Link the declarative config from your repository
  xdg.configFile."nvim".source = ../config/nvim;

  home.packages = with pkgs; [
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