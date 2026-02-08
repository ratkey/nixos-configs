{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    keyMode = "vi";

    # We set the prefix here to avoid conflicts, but we rebind it in extraConfig below
    prefix = "M-s";

    # NixOS handles plugin installation automatically (No more TPM!)
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
      resurrect
      continuum

      # Gruvbox theme
      {
        plugin = gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox 'dark'
          set -g @tmux-gruvbox-statusbar-alpha 'true'
        '';
      }
    ];

    extraConfig = ''
      # --- Global Options ---
      set-option -g default-shell ${pkgs.fish}/bin/fish
      set-option -g status-position top
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -g renumber-windows on

      # --- Keybindings ---
      
      # Split panes using | and - (preserving path)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D 
      bind k select-pane -U
      bind l select-pane -R

      # Alt-arrow keys to switch panes (No prefix)
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      # Copy mode like vi
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Continuum / Resurrect settings
      set -g @resurrect-strategy-vim 'session'
      set -g @resurrect-strategy-nvim 'session'
      set -g @continuum-boot 'on'
    '';
  };
}
