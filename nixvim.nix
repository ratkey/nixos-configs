{...}:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    version.enableNixpkgsReleaseCheck = false;
    globals.mapleader = " ";
    
    settings = {
      vim.opt = {
        number = true;
        relativenumber = true;
        expandtab = true;
	# set tabs to 2 spaces
        tabstop = 2;
        shiftwidth = 2;
	spandtab = true;
	shifttabstop = 2;
	smartindent = true;

        ignorecase = true;
        smartcase = true;
        clipboard = "unnamedplus";
        cursorline = true;
        wrap = false;
      };
    };
    
    colorschemes.gruvbox.enable = true;
    
    plugins = {
      treesitter.enable = true;
      web-devicons.enable = true;
      telescope.enable = true;
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
