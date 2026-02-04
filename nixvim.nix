{config, pkgs, ...}:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    version.enableNixpkgsReleaseCheck = false;
    globals.mapleader = " ";

    extraPackages = with pkgs; [
    	nodePackages.prettier
    ];
    
    opts = {
        number = true;
        ignorecase = true;
        smartcase = true;
        cursorline = true;
        wrap = false;
        clipboard = "unnamedplus";
	      # set tabs to 2 spaces
        expandtab = true;
        tabstop = 2;
        shiftwidth = 2;
	      softtabstop = 2;
	      smartindent = true;
    };
    
    colorschemes.gruvbox.enable = true;

# This triggers the format on save
    autoCmd = [
      {
        event = [ "BufWritePre" ];
        pattern = [ "*" ];
        callback = {
          __raw = ''
            function()
              vim.lsp.buf.format({ async = false })
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
          # This enables Prettier
          prettier = {
            enable = true;
            disableTsServerFormatter = true; # Prevents conflicts with ts_ls
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
