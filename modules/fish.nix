{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_vi_key_bindings

      function fish_mode_prompt
        switch $fish_bind_mode
          case default
            set_color --bold --background fe8019 282828
            echo ' N '
            set_color normal
          case insert
            set_color --bold --background b8bb26 282828
            echo ' I '
            set_color normal
          case visual
            set_color --bold --background fabd2f 282828
            echo ' V '
            set_color normal
          case replace_one
            set_color --bold --background d3869b 282828
            echo ' R '
            set_color normal
        end
        echo -n " "
      end
    '';
    shellAliases = {
      btw = "echo I use nixos, btw";
      fix-brave = "rm -rf ~/.config/BraveSoftware/Brave-Browser/Singleton* && brave &";
    };
  };

  programs.oh-my-posh = {
    enable = true;
    useTheme = "gruvbox";
  };
}
