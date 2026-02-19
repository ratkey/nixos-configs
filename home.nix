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
    (pkgs.writeShellScriptBin "wallpaper-selector" ''
      #!/usr/bin/env bash
      WALLPAPER_DIR="$HOME/walls"
      CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"

      if [ ! -d "$WALLPAPER_DIR" ]; then
        mkdir -p "$WALLPAPER_DIR"
        notify-send "Wallpaper Selector" "Created directory $WALLPAPER_DIR. Put your wallpapers there."
        exit 1
      fi

      # Select wallpaper using rofi with dmenu mode
      # Exclude existing 'wall.*' files from the list to avoid duplication/confusion
      SELECTED=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -not -name "wall.*" | sort | while read -r img; do
        echo -en "$(basename "$img")\0icon\x1f$img\n"
      done | rofi -dmenu -p "Select Wallpaper" -show-icons -theme-str 'window { width: 60%; } listview { columns: 4; lines: 3; spacing: 20px; } element { orientation: vertical; padding: 10px; } element-icon { size: 120px; horizontal-align: 0.5; } element-text { horizontal-align: 0.5; }')

      if [ -n "$SELECTED" ]; then
        # Find the full path of the selected file
        SOURCE_PATH=$(find "$WALLPAPER_DIR" -name "$SELECTED" -print -quit)

        if [ -z "$SOURCE_PATH" ]; then
            notify-send "Error" "Could not find source image for $SELECTED"
            exit 1
        fi

        # Get extension
        EXT="''${SELECTED##*.}"
        TARGET="$WALLPAPER_DIR/wall.$EXT"

        # Remove old wall files
        rm -f "$WALLPAPER_DIR"/wall.*

        # Copy new wallpaper to standard location
        cp "$SOURCE_PATH" "$TARGET"
        
        # Write config pointing to the standard 'wall' file
        echo "preload = $TARGET" > "$CONFIG_FILE"
        echo "wallpaper = ,$TARGET" >> "$CONFIG_FILE"

        # Restart hyprpaper
        pkill hyprpaper
        sleep 0.5 
        hyprpaper &

        notify-send "Wallpaper" "Set to $SELECTED"
      fi
    '')
    (pkgs.writeShellScriptBin "rofi-power" ''
      #!/usr/bin/env bash
      entries="Suspend\nReboot\nShutdown"
      selected=$(echo -e "$entries" | rofi -dmenu -p "Power Menu")
      case $selected in
        Suspend)
          systemctl suspend
          ;;
        Reboot)
          systemctl reboot
          ;;
        Shutdown)
          systemctl poweroff
          ;;
      esac
    '')
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
