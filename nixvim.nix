{ config, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    version.enableNixpkgsReleaseCheck = false;
    globals.mapleader = " ";

    # 1. Added Black (Python) and Nixpkgs-fmt (Nix) here so they are available
    extraPackages = with pkgs; [
      nodePackages.prettier
      black
      nixpkgs-fmt
    ];

    opts = {
      number = true;
      ignorecase = true;
      smartcase = true;
      cursorline = true;
      wrap = false;
      clipboard = "unnamedplus";

      # Tab settings (2 spaces)
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      smartindent = true;
    };

    colorschemes.gruvbox.enable = true;

    # 2. Updated AutoCmd to prevent "ts_ls" from fighting Prettier
    autoCmd = [
      {
        event = [ "BufWritePre" ];
        pattern = [ "*" ];
        callback = {
          __raw = ''
            function(args)
              vim.lsp.buf.format({
                async = false,
                bufnr = args.buf,
                filter = function(client)
                  -- Prevent ts_ls from formatting (let Prettier do it)
                  return client.name ~= "ts_ls"
                end
              })
            end
          '';
        };
      }
    ];

    plugins = {
      treesitter.enable = true;
      web-devicons.enable = true;
      telescope.enable = true;

      none-ls = {
        enable = true;
        sources.formatting = {
          # JS/TS/HTML/CSS
          prettier = {
            enable = true;
            disableTsServerFormatter = true;
          };
          # Python
          black = {
            enable = true;
            settings = ''
              {
                extra_args = { "--fast" },
              }
            '';
          };
          # Nix
          nixpkgs_fmt.enable = true;
        };
      };

      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          lua_ls.enable = true;
          pyright.enable = true;
          ts_ls.enable = true;
          css_ls.enable = true;
        };
      };

      lspsaga.enable = true;
      nvim-autopairs.enable = true;
      nvim-surround.enable = true;
      comment-nvim.enable = true;
      indent-blankline.enable = true;
      gitsigns.enable = true;
      oil.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.noremap = true;
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.noremap = true;
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options.noremap = true;
        options.silent = true;
      }
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<CR>";
      }
    ];
  };
}
