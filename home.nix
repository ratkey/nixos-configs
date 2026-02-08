{ config, pkgs, lib, nixvim, ... }: {
  home.username = "cother";
  home.homeDirectory = "/home/cother";
  home.stateVersion = "25.11";

  imports = [
    nixvim.homeModules.nixvim
    ./modules/kitty.nix
    ./modules/nixvim.nix
    ./modules/tmux.nix
    ./modules/zellij.nix
    ./modules/wofi.nix
    ./modules/dunst.nix
    ./modules/git.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    pamixer
    vscode
    brightnessctl
    hyprpaper
    waybar
    fastfetch
    bluetui
    blueman # The standard GTK Bluetooth manager (GUI)
    bluez # Core Bluetooth utilities (includes bluetoothctl)
    bluez-tools # Extra CLI tools
    grim # The screenshot tool
    slurp # The region selector
    libnotify # Notification alerts
    yaak # GUI api client
  ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, btw";
      fix-brave = "rm -rf ~/.config/BraveSoftware/Brave-Browser/Singleton* && brave &";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec hyprland
      fi
      ssh-add ~/.ssh/id_ed25519 2>/dev/null
    '';
    initExtra = ''
      set -o vi
    '';
  };
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/waybar".source = ./config/waybar;

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
    };
    iconTheme = {
      name = "Adwaita";
    };
  };
}
