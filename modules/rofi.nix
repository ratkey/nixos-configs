{ pkgs, config, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    extraConfig = {
      modi = "drun";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      sidebar-mode = true;
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg-col = mkLiteral "rgba(40, 40, 40, 0.9)";
        bg-col-light = mkLiteral "rgba(40, 40, 40, 0.9)";
        border-col = mkLiteral "#fabd2f";
        selected-col = mkLiteral "#fabd2f";
        blue = mkLiteral "#83a598";
        fg-col = mkLiteral "#ebdbb2";
        fg-col2 = mkLiteral "#282828";
        grey = mkLiteral "#928374";
        width = 600;
        font = "JetBrainsMono Nerd Font 14";
      };

      "element-text, element-icon , mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "window" = {
        height = mkLiteral "360px";
        border = mkLiteral "2px";
        border-color = mkLiteral "@border-col";
        background-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "5px";
      };

      "mainbox" = {
        background-color = mkLiteral "transparent";
      };

      "inputbar" = {
        children = map mkLiteral [ "prompt" "entry" ];
        background-color = mkLiteral "transparent";
        border-radius = mkLiteral "5px";
        padding = mkLiteral "2px";
      };

      "prompt" = {
        background-color = mkLiteral "@blue";
        padding = mkLiteral "6px";
        text-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "3px";
        margin = mkLiteral "20px 0px 0px 20px";
      };

      "textbox-prompt-colon" = {
        expand = false;
        str = ":";
      };

      "entry" = {
        padding = mkLiteral "6px";
        margin = mkLiteral "20px 0px 0px 10px";
        text-color = mkLiteral "@fg-col";
        background-color = mkLiteral "transparent";
      };

      "listview" = {
        border = mkLiteral "0px 0px 0px";
        padding = mkLiteral "6px 0px 0px";
        margin = mkLiteral "10px 0px 0px 20px";
        columns = 2;
        lines = 5;
        background-color = mkLiteral "transparent";
      };

      "element" = {
        padding = mkLiteral "5px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-col";
      };

      "element-icon" = {
        size = mkLiteral "25px";
      };

      "element selected" = {
        background-color = mkLiteral "@selected-col";
        text-color = mkLiteral "@fg-col2";
        border-radius = mkLiteral "3px";
      };

      "mode-switcher" = {
        spacing = 0;
      };

      "button" = {
        padding = mkLiteral "10px";
        background-color = mkLiteral "@bg-col-light";
        text-color = mkLiteral "@grey";
        vertical-align = mkLiteral "0.5"; 
        horizontal-align = mkLiteral "0.5";
      };

      "button selected" = {
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@blue";
      };
    };
  };
}
