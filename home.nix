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
    ./modules/fastfetch.nix
    ./modules/obsidian.nix
    ./modules/hyprland.nix
    ./modules/quickshell.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    pamixer
    vscode
    brightnessctl
    swww
    obs-studio
    vlc
    bluetui
    blueman # The standard GTK Bluetooth manager (GUI)
    bluez # Core Bluetooth utilities (includes bluetoothctl)
    bluez-tools # Extra CLI tools
    grim # The screenshot tool
    slurp # The region selector
    libnotify # Notification alerts
    yaak # GUI api client
    gemini-cli
    claude-code
    krita # Drawing
    firefox # Browser
    azahar # Nintendo 3DS emulator
    localsend # GUI for sharing files acrross network
    yazi # TUI file manager
    nwg-displays # GUI for configuring Monitors
    waypaper # GUI wallpaper selector for swww
  ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.file.".config/waypaper/config.ini".text = ''
    [Settings]
    folder = ~/walls
    backend = swww
    fill = fill
    sort = name
    color = #282828
    subfolders = false
  '';
}
