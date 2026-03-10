{ config, pkgs, lib, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Monitor
      monitor = "eDP-1,1680x1050@60,0x0,1.0";

      # Programs
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$browser" = "brave";
      "$menu" = "rofi -show drun";
      "$reload_hyprland" = "hyprctl reload";
      "$mainMod" = "SUPER";

      # Autostart
      exec-once = [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "$terminal"
        "qs &"
        "swww-daemon &"
        "swww img /home/cother/walls/wall.jpg"
        "hypridle &"
        "hyprlock"
      ];

      # Environment variables
      env = [
        "XCURSOR_THEME,Bibata-Modern-Classic"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE,24"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
      ];

      # General
      general = {
        gaps_in = 4;
        gaps_out = 4;
        border_size = 2;
        "col.active_border" = "rgba(fabd2fee) rgba(98971aee) 45deg";
        "col.inactive_border" = "rgba(504945ee)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 5;
        rounding_power = 4;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layouts
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      # Misc
      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
      };

      # Input
      input = {
        kb_layout = "latam";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0;
        repeat_rate = 35;
        repeat_delay = 200;

        touchpad = {
          natural_scroll = true;
        };
      };

      cursor = {
        inactive_timeout = 30;
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = "-0.5";
      };

      # Keybindings
      bind = [
        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" /tmp/screenshot.png && wl-copy < /tmp/screenshot.png && notify-send -i /tmp/screenshot.png \"Screenshot\" \"Region copied to clipboard\""
        "CTRL, Print, exec, grim /tmp/screenshot.png && wl-copy < /tmp/screenshot.png && notify-send -i /tmp/screenshot.png \"Screenshot\" \"Fullscreen copied to clipboard\""
        "SUPER, Print, exec, FILE=~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S.png'); grim $FILE && notify-send -i $FILE \"Screenshot\" \"Saved to $FILE\""

        # Applications
        "$mainMod, Return, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT, Q, exec, rofi-power"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, W, exec, $browser"
        "$mainMod SHIFT, W, exec, wallpaper-selector"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, $menu"
        "$mainMod SHIFT, R, exec, $reload_hyprland"

        # Focus movement (vim-style)
        "$mainMod, l, movefocus, l"
        "$mainMod, h, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Window movement
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Lock screen
        "$mainMod ALT, L, exec, hyprlock"
      ];

      # Repeat bindings (volume/brightness)
      bindle = [
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      # Locked bindings (work when locked)
      bindl = [
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioMicMute, exec, pamixer --default-source -t"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Window rules
      windowrulev2 = "suppressevent maximize, class:.*";

      # Layer rules
      layerrule = [
        "blur, quickshell"
        "blur, rofi"
        "ignorezero, rofi"
      ];
    };
  };
}
