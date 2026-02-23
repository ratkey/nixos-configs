{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      gs = "git status";
      cls = "clear";
      btw = "echo I use nixos, btw";
      fix-brave = "rm -rf ~/.config/BraveSoftware/Brave-Browser/Singleton* && brave &";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec hyprland
      fi
      ssh-add ~/.ssh/id_ed25519 2>/dev/null
    '';
    initExtra = ''
      set -o vi
    '';
  };
}
