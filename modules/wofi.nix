{ ... }:
{
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

  xdg.configFile."wofi/style.css".text = ''
    window {
        margin: 0px;
        border: 2px solid #fabd2f; /* Changed border size to 2px */
        background-color: transparent;
        border-radius: 5px;
    }

    #input {
        all: unset;
        min-height: 30px;
        filter: none;
        border: none;
        color: #ebdbb2;
        font-size: 20px;
        background-image: none;
        margin: 10px;
        background-color: #3c3836;
        border-radius: 5px;
        padding: 5px;
    }

    #inner-box {
        margin: 20px;
        background-color: transparent;
    }

    #outer-box {
        margin: 0px;
        background-color: rgba(40, 40, 40, 0.9);
        border-radius: 5px;
    }

    #scroll {
        margin: 0px;
        border: none;
    }

    #text {
        margin: 5px;
        color: #ebdbb2;
    }

    #entry {
        margin: 5px;
        border-radius: 5px;
        border: none;
        background-color: #3c3836;
        color: #ebdbb2;
    }

    #entry:selected {
        background-color: #fabd2f;
        color: #282828; /* Changed selected text to dark */
    }
  '';

  xdg.configFile."wofi/wallpaper.css".text = ''
    window {
        margin: 0px;
        border: 2px solid #fabd2f; /* Changed border size to 2px */
        background-color: transparent;
        border-radius: 5px;
    }

    #input {
        all: unset;
        min-height: 30px;
        filter: none;
        border: none;
        color: #ebdbb2;
        font-size: 20px;
        background-image: none;
        margin: 10px;
        background-color: #3c3836;
        border-radius: 5px;
        padding: 5px;
    }

    #inner-box {
        margin: 20px;
        background-color: transparent;
    }

    #outer-box {
        margin: 0px;
        background-color: rgba(40, 40, 40, 0.9);
        border-radius: 5px;
    }

    #scroll {
        margin: 0px;
        border: none;
    }

    #text {
        margin: 5px;
        color: #ebdbb2;
        text-align: center;
    }

    #img {
        margin-right: 0px;
        margin-bottom: 5px;
    }

    #entry {
        margin: 5px;
        border-radius: 5px;
        border: none;
        background-color: #3c3836;
        color: #ebdbb2;
        box-orient: vertical;
        box-pack: center;
        box-align: center;
    }

    #entry:selected {
        background-color: #fabd2f;
        color: #282828; /* Changed selected text to dark */
    }
  '';
}
