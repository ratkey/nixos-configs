{ ... }:
{
  programs.kitty = {
    enable = true;

    # Pick a theme (Gruvbox to match your Neovim/Zellij)
    theme = "Gruvbox Dark";

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      # Essential Settings
      confirm_os_window_close = 0; # Close window without asking
      enable_audio_bell = false; # Silence the bell
      update_check_interval = 0; # No updates (Nix manages this)

      # Visuals
      background_opacity = "0.95"; # Slight transparency
      window_padding_width = 10; # Breathing room for text
      cursor_shape = "block";

      # Tab Bar (if you use tabs in Kitty, though Zellij is better)
      tab_bar_style = "powerline";
    };

    # Keybindings (if needed, otherwise defaults are fine)
    # keybindings = {
    #   "ctrl+c" = "copy_to_clipboard";
    #   "ctrl+v" = "paste_from_clipboard";
    # };
  };
}
