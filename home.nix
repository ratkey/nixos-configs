{config, pkgs, ...}: {
  home.username = "cother";
  home.homeDirectory = "/home/cother";
  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    pamixer
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
  home.file.".config/hypr".source = ./config/hypr;
}
