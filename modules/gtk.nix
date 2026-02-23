{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };
    iconTheme = {
      name = "Adwaita";
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
}
