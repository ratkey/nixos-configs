{ config, pkgs, ... }:
{
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "gruvbox";
      theme_background = false;
      vim_keys = true;
    };
  };
}
