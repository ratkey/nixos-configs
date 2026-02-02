{config, pkgs, ...}: {
  home.username = "cother";
  home.homeDirectory = "/home/cother";
  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    pamixer
    vscode
    brightnessctl
  ];
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, btw";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec hyprland
      fi
    '';
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = ''
      vim.opt.clipboard =  "unnamedplus"
    '';
  };
  programs.git = {
    enable = true;
    userName = "cother";
    userEmail = "cother@protonmail.com";
    extraConfig =  {
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
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      wallpaper = [
        {
	  monitor = "";
	  path = "/home/cother/walls/wall1.jpg";
	  fit_mode = "cover";
	}
      ];
    };
  };
  home.file.".config/hypr".source = ./config/hypr;
}
