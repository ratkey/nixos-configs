{ config, pkgs, lib, ... }: {
  home.username = "cother";
  home.homeDirectory = "/home/cother";
  home.stateVersion = "25.11";

  imports = [
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
    gemini-cli
    krita
  ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      gs = "git status";
      cls = "clear";
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

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };
    iconTheme = {
      name = "Adwaita";
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
}
