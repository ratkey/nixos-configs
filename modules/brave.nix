{ pkgs, ... }:
{
  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--password-store=basic"
    ];
  };
}
