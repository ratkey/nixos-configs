{config, pkgs, lib, nixvim, ...}: {
  home.username = "cother";
  home.homeDirectory = "/home/cother";
  home.stateVersion = "25.11";

  imports = [
    nixvim.homeModules.nixvim
    ./nixvim.nix
  ];
  
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    pamixer
    vscode
    brightnessctl
    direnv
    hyprpaper
    waybar
  ];
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
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "cother";
      user.email = "cother@protonmail.com";
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
  programs.wofi = {
    enable = true;
    settings = {
      width = 400;
      height = 300;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 24;
    };
  };
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    prefix = "M-s";
    terminal = "screen-256color";
    extraConfig = ''
      # Vim-like pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Vim-like pane resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Split panes with | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Reload config with prefix + r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Copy mode vim bindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

      # Easier window navigation
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      # Status bar styling
      set -g status-style bg=black,fg=white
      set -g status-left "[#S] "
      set -g status-right "%H:%M %d-%b-%y"
      set -g window-status-current-style bg=blue,fg=black,bold
      
      # Pane border colors
      set -g pane-border-style fg=colour238
      set -g pane-active-border-style fg=colour39

      # Enable focus events for vim
      set -g focus-events on
    '';
  };
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/waybar".source = ./config/waybar;
}
