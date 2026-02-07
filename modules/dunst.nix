{ config, pkgs, ... }:
{

  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Visuals
        font = "JetBrainsMono Nerd Font 10";
        width = 300;
        height = 100;
        origin = "top-right";
        offset = "20x20";
        frame_width = 2;
        corner_radius = 5;

        # Gruvbox Dark Colors
        frame_color = "#fabd2f"; # Gruvbox Yellow border
        separator_color = "frame";

        # Enable icons/images on the left side
        icon_position = "left";

        # Optional: Limit size so huge screenshots don't cover the screen
        max_icon_size = 128;
      };

      urgency_normal = {
        background = "#282828"; # Gruvbox Dark Background
        foreground = "#ebdbb2"; # Gruvbox Light Text
        timeout = 5; # Disappears after 5 seconds
      };

      urgency_critical = {
        background = "#cc241d"; # Gruvbox Red
        foreground = "#ebdbb2";
        frame_color = "#fb4934";
        timeout = 0; # Stays until you click it
      };
    };
  };
}
