{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # --- Bootloader Configuration ---
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  # --- Networking ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # --- Localization & Timezone ---
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_MX.UTF-8";
    LC_IDENTIFICATION = "es_MX.UTF-8";
    LC_MEASUREMENT = "es_MX.UTF-8";
    LC_MONETARY = "es_MX.UTF-8";
    LC_NAME = "es_MX.UTF-8";
    LC_NUMERIC = "es_MX.UTF-8";
    LC_PAPER = "es_MX.UTF-8";
    LC_TELEPHONE = "es_MX.UTF-8";
    LC_TIME = "es_MX.UTF-8";
  };

  # --- Keymaps (Console & X11) ---
  console.keyMap = "la-latin1";
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  # --- User Configuration ---
  services.getty.autologinUser = "cother";
  
  users.users.cother = {
    isNormalUser = true;
    description = "cother";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # --- System Packages & Settings ---
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
  ];

  # --- Desktop Environment (Hyprland) ---
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.hyprlock.enable = true;

  # --- Fonts ---
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # --- Hardware Support ---
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Enables battery percentage reporting
      };
    };
  };

  # Graphics Tablet
  hardware.opentabletdriver.enable = true;

  # --- Services ---
  # File Management Services
  services.gvfs.enable = true;    # Mount, trash, and other functionality
  services.tumbler.enable = true; # Thumbnail support for images

  # Audio (Pipewire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- Nix Configuration ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.11";
}