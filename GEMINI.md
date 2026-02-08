# NixOS Configuration Analysis

This directory contains a **NixOS configuration** managed with **Nix Flakes** and **Home Manager**. It defines the system state for a machine named `nixos` and the user environment for `cother`.

## Project Structure

- **`flake.nix`**: The entry point. Defines inputs (nixpkgs, home-manager, nixvim) and the system output (`nixosConfigurations.nixos`).
- **`configuration.nix`**: System-wide configuration (bootloader, networking, hardware, system packages, global services like Pipewire and Bluetooth).
- **`home.nix`**: User-specific configuration managed by Home Manager. Handles dotfiles, user packages, and shell configuration.
- **`modules/`**: Contains modularized configurations for specific tools imported by `home.nix`:
  - `dunst.nix`, `git.nix`, `kitty.nix`, `nixvim.nix`, `tmux.nix`, `wofi.nix`, `zellij.nix`.
- **`config/`**: Directory containing raw configuration files (e.g., Hyprland, Waybar) that are symlinked/managed by Home Manager.
  - `config/hypr/` -> `~/.config/hypr`
  - `config/waybar/` -> `~/.config/waybar`

## Key Technologies & Settings

- **System:** NixOS 25.11 (`x86_64-linux`)
- **Desktop Environment:** Hyprland (Wayland compositor)
- **Bar:** Waybar
- **Editor:** Neovim (via `nixvim` flake input)
- **Shell:** Bash (with `vi` mode and custom aliases)
- **Audio:** Pipewire (PulseAudio & ALSA compatibility enabled)
- **Locale:** `en_US.UTF-8` (System), `es_MX.UTF-8` (Formats), `America/Mexico_City` (Timezone)
- **Keyboard:** `latam` (X11), `la-latin1` (Console)

## Management Commands

### Apply System Changes

To apply changes made to any file (`configuration.nix`, `home.nix`, or modules), run:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

_Note: Since Home Manager is integrated as a NixOS module, this command updates both the system and the user environment. **The agent should never execute `sudo nixos-rebuild switch --flake .#nixos`; this command is reserved for the user.**_

### Update Dependencies

To update the flake inputs (nixpkgs, home-manager, etc.) to their latest versions:

```bash
nix flake update
```

## Development Conventions

- **Modularity:** New user tools/configurations should be added as files in `modules/` and imported in `home.nix`.
- **Static Configs:** Complex or non-Nix configuration files (like Hyprland confs) are kept in `config/` and referenced in `home.nix` using `home.file.".config/<path>".source`.
- **Secrets:** No secret management (like sops-nix or agenix) is currently visible. Ensure no sensitive tokens are committed to `configuration.nix` or `home.nix`.
- **Style** Use the Gruvbox Dark color scheme
