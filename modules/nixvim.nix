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


      # Add smart-splits to your plugins
      smart-splits = {
        enable = true;
        settings = {
          # Optional: Prevent the cursor from looping around when you hit the edge
          at_edge = "stop";
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

    # Add these mappings to your keymaps list
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
      # Resize with Alt+Arrows
      {
        mode = "n";
        key = "<M-Up>";
        action = "<cmd>lua require('smart-splits').resize_up()<CR>";
      }
      {
        mode = "n";
        key = "<M-Down>";
        action = "<cmd>lua require('smart-splits').resize_down()<CR>";
      }
      {
        mode = "n";
        key = "<M-Left>";
        action = "<cmd>lua require('smart-splits').resize_left()<CR>";
      }
      {
        mode = "n";
        key = "<M-Right>";
        action = "<cmd>lua require('smart-splits').resize_right()<CR>";
      }

      # Move cursor with Alt+h/j/k/l
      {
        mode = "n";
        key = "<M-h>";
        action = "<cmd>lua require('smart-splits').move_cursor_left()<CR>";
      }
      {
        mode = "n";
        key = "<M-j>";
        action = "<cmd>lua require('smart-splits').move_cursor_down()<CR>";
      }
      {
        mode = "n";
        key = "<M-k>";
        action = "<cmd>lua require('smart-splits').move_cursor_up()<CR>";
      }
      {
        mode = "n";
        key = "<M-l>";
        action = "<cmd>lua require('smart-splits').move_cursor_right()<CR>";
      }
    ];
  };
}
