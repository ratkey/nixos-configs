{ config, pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    # enableZshIntegration = true; # Uncomment if you want zsh integration

    settings = {
      theme = "gruvbox-dark";
      # default_layout = "compact";
      pane_frames = false;
      mouse_mode = true;
      copy_command = "wl-copy";

      keybinds = {
        "shared_except \"locked\"" = {
          # Fix: Actions without arguments must be assigned an empty set {}

          # Split panes
          "bind \"|\"" = { NewPane = "Right"; };
          "bind \"-\"" = { NewPane = "Down"; };

          # Shift arrow to switch Tabs
          "bind \"Shift Left\"" = { GoToPreviousTab = { }; };
          "bind \"Shift Right\"" = { GoToNextTab = { }; };

          # Alt + H/L to switch Tabs
          "bind \"Alt H\"" = { GoToPreviousTab = { }; };
          "bind \"Alt L\"" = { GoToNextTab = { }; };

          # Vim Navigation
          "bind \"Alt h\"" = { MoveFocus = "Left"; };
          "bind \"Alt j\"" = { MoveFocus = "Down"; };
          "bind \"Alt k\"" = { MoveFocus = "Up"; };
          "bind \"Alt l\"" = { MoveFocus = "Right"; };
        };
      };
    };
  };
}
