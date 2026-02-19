{ pkgs, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
      };

      background = [
        {
          path = "/home/cother/walls/wall.jpg";
          blur_passes = 2;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          size = "250, 60";
          position = "0, 100";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(235, 219, 178)";
          inner_color = "rgb(40, 40, 40)";
          outer_color = "rgb(250, 189, 47)";
          outline_thickness = 2;
          placeholder_text = "<i>Input Password...</i>";
          shadow_passes = 2;
        }
      ];

      label = [
        {
          text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
          color = "rgba(235, 219, 178, 1.0)";
          font_size = 120;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }
        {
          text = ".::$USER::.";
          color = "rgba(235, 219, 178, 1.0)";
          font_size = 25;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -40";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
