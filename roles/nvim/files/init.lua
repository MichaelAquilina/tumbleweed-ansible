local vim = vim

vim.g.cp = false;

-- old init.vim code will slowly be migrated out of this file
vim.cmd("source ~/.config/nvim/legacy.vim");

vim.o.termguicolors = true;
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 0

vim.g.mapleader = " ";

-- Python configuration
vim.python_host_prog = '/usr/bin/python';
vim.python3_host_prog = '/usr/bin/python3';

local packer = require('packer');
packer.startup(function(use)
  use('wbthomason/packer.nvim');

  -- colorscheme
  use({'folke/tokyonight.nvim', branch = 'main' });

  -- Functionality
  use('sheerun/vim-polyglot');
  use({'kyazdani42/nvim-tree.lua', tag = '1.2.8'});
  use('norcalli/nvim-colorizer.lua');
  use('lukas-reineke/indent-blankline.nvim');

  use('Pocco81/AutoSave.nvim')
  use('svermeulen/vimpeccable')  -- keymaps in lua

  -- Telescope
  use({
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  })
  use({'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

  -- LSP
  use('neovim/nvim-lspconfig');
  use('glepnir/lspsaga.nvim');
  use('ray-x/lsp_signature.nvim');
  use('williamboman/nvim-lsp-installer');
  use('hrsh7th/nvim-cmp');
  use('hrsh7th/cmp-nvim-lsp');
  use('L3MON4D3/LuaSnip');
  use('saadparwaiz1/cmp_luasnip');
  use('onsails/lspkind-nvim');

  -- Textobjects
  use('kana/vim-textobj-user');
  use('jeetsukumaran/vim-pythonsense');
  use('sgur/vim-textobj-parameter');

  -- Treesitter
  use({'nvim-treesitter/nvim-treesitter'});

  -- Git
  use('airblade/vim-gitgutter');
  use('tpope/vim-fugitive');
  use('tpope/vim-rhubarb');

  use('tpope/vim-sleuth');  -- Automatic tab expand configuration
  use('tpope/vim-commentary');  -- Comment out blocks of code
  use('tpope/vim-surround');  -- change surrounding elements
end);


vim.g.tokyonight_style = 'night';
vim.cmd("colorscheme tokyonight");

-- Telescope
local telescope = require('telescope')
telescope.setup({
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  },
  pickers = {
    buffers = {
      ignore_current_buffer = true,
      sort_mru = true,
      sort_lastused = true,
    }
  }
});
telescope.load_extension("fzf");

-- Colorizer

require('colorizer').setup()

-- Autosave

local autosave = require("autosave")
autosave.setup({
  write_all_buffers = true,
  events = {"BufLeave", "FocusLost"}
})

-- Treesitter configuration

local treesitter = require('nvim-treesitter.configs')
treesitter.setup {
    ensure_installed = "all",
    highlight = {
      enable = true
    }
}

-- Lsp configuration
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')
local lsp_installer = require('nvim-lsp-installer')
lsp_installer.on_server_ready(function (server) server:setup { capabilities = capabilities } end)

local saga = require('lspsaga')
saga.init_lsp_saga({
  code_action_prompt = {enable = false}
});

local lspkind = require('lspkind');
lspkind.init({})

local cmp = require('cmp')
cmp.setup {
 snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
  end,
 },
 mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
 },
 sources = cmp.config.sources({
  { name = 'nvim_lsp' }
 })
};

-- NvimTree

vim.g.nvim_tree_ignore = { '.git' }
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_show_icons = {
    git = 0,
    folders= 1,
    files = 0,
    folder_arrows = 1,
};

-- Keymaps in vimpeccable

local vimp = require('vimp')
vimp.always_override = true;

vimp.nnoremap('<leader>ev', ':edit $MYVIMRC<cr>')
vimp.nnoremap('<leader>el', ':edit ~/.config/nvim/init.lua<cr>')
vimp.nnoremap('<leader>sv', ':source $MYVIMRC<cr>')
vimp.nnoremap('<leader>ez', ':edit ~/.zshrc<cr>')
vimp.nnoremap('<leader>es', ':edit ~/.config/sway/config<cr>')
vimp.nnoremap('<leader>et', ':edit ~/.config/kitty/kitty.conf<cr>')

vimp.nnoremap('<c-p>', ':Telescope find_files find_command=rg,--ignore,-g,!.git/,--hidden,--files<cr>')
vimp.nnoremap('<c-b>', ':Telescope buffers<cr>')
vimp.nnoremap('<c-k>', ':Telescope live_grep<cr>')

vimp.vnoremap('cp', '"+y')
vimp.nnoremap('vp', '"+p')

vimp.nnoremap('Q', '<nop>') -- Disable Ex mode
vimp.nnoremap('<c-s>', '<nop>') -- Disable stop redraw

vimp.nnoremap('<esc>',':let @/=""<cr>') -- Cancel current search

-- Quickly move lines up and down
vimp.nnoremap('-', 'ddp')
vimp.nnoremap('_', 'ddkP')

vimp.nnoremap('<leader>,', ':call CopyRelativePath(0)<cr>')
vimp.nnoremap('<leader>.', ':call CopyRelativePath(1)<cr>')

vimp.nmap('<leader>]', '<Plug>(GitGutterNextHunk)')
vimp.nmap('<leader>[', '<Plug>(GitGutterPrevHunk)')

vimp.nnoremap('gs', ':Lspsaga signature_help<CR>')
vimp.nnoremap('K', ':Lspsaga hover_doc<CR>')
vimp.nnoremap('gd', ':lua vim.lsp.buf.definition()<CR>')

vimp.vnoremap('<leader>gb', ':GBrowse<cr>')

vimp.nnoremap('<leader>/', ':NvimTreeToggle<cr>')

-- Miscellaneous options

vim.o.list = true;
vim.o.completeopt = "menuone,noinsert,noselect";
vim.o.encoding = "utf-8";
vim.o.emoji = true;
vim.o.inccommand =  "nosplit"  -- Enable previewing of %s//
vim.o.mouse = "a"
vim.o.wrap = false;
vim.o.number = true;
vim.o.hidden = true;
vim.o.backup = false;
vim.o.writebackup = false;
vim.o.swapfile = false;
vim.o.cursorline = true;
vim.o.cursorcolumn = true;
