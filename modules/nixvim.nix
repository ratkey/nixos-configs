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

      ripgrep
      fd
      typescript
      astro-language-server
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

    plugins = {
      treesitter.enable = true;
      web-devicons.enable = true;
      telescope.enable = true;

      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            javascriptreact = [ "prettier" ];
            typescriptreact = [ "prettier" ];
            css = [ "prettier" ];
            html = [ "prettier" ];
            json = [ "prettier" ];
            yaml = [ "prettier" ];
            markdown = [ "prettier" ];
            astro = [ "prettier" ];
            python = [ "black" ];
            nix = [ "nixpkgs_fmt" ];
          };
          formatters = {
            black = {
              prepend_args = [ "--fast" ];
            };
          };
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 500;
          };
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
          astro_ls = {
            enable = true;
            settings = {
              typescript = {
                # tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
              };
            };
          };
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
      oil = {
        enable = true;
        settings = {
          view_options = {
            show_hidden = true;
          };
        };
      };
    };

    # Add these mappings to your keymaps list
    keymaps = [
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        options.noremap = true;
        options.silent = true;
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.noremap = true;
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader><leader>";
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
