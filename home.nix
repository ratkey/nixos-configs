{ config, pkgs, lib, ... }: {
  home.username = "cother";
  home.homeDirectory = "/home/cother";
  home.stateVersion = "25.11";

  imports = [
    ./modules/bash.nix
    ./modules/fish.nix
    ./modules/kitty.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/zellij.nix
    ./modules/rofi.nix
    ./modules/dunst.nix
    ./modules/git.nix
    ./modules/brave.nix
    ./modules/btop.nix
    ./modules/nautilus.nix
    ./modules/hyprlock.nix
    ./modules/hypridle.nix
    ./modules/cursor.nix
    ./modules/gtk.nix
    ./modules/eza.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    pamixer
    vscode
    brightnessctl
    hyprpaper
    waybar
    quickshell
    fastfetch
    bluetui
    blueman # The standard GTK Bluetooth manager (GUI)
    bluez # Core Bluetooth utilities (includes bluetoothctl)
    bluez-tools # Extra CLI tools
    grim # The screenshot tool
    slurp # The region selector
    libnotify # Notification alerts
    yaak # GUI api client
    gemini-cli
    krita
    firefox
  ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.file.".config/quickshell/shell.qml".source = ./config/quickshell/shell.qml;
  home.file.".config/hypr/hyprland.conf".source = ./config/hypr/hyprland.conf;
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/cother/walls/wall.jpg
    wallpaper = ,/home/cother/walls/wall.jpg
  '';
  home.file.".config/waybar".source = ./config/waybar;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

}
