local vim = vim

vim.o.termguicolors = true;

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
  use('kyazdani42/nvim-tree.lua');
  use('norcalli/nvim-colorizer.lua');
  use('lukas-reineke/indent-blankline.nvim');
  use({
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  })
  use('Pocco81/AutoSave.nvim')
  use('svermeulen/vimpeccable')  -- keymaps in lua

  -- LSP
  use('neovim/nvim-lspconfig');
  use('glepnir/lspsaga.nvim');
  use('ray-x/lsp_signature.nvim');
  use('kabouzeid/nvim-lspinstall');
  use('hrsh7th/nvim-compe');
  use('onsails/lspkind-nvim');

  -- Textobjects
  use('kana/vim-textobj-user');
  use('jeetsukumaran/vim-pythonsense');
  use('sgur/vim-textobj-parameter');

  -- Treesitter
  use({'nvim-treesitter/nvim-treesitter', branch = '0.5-compat'});

  -- Git
  use('airblade/vim-gitgutter');
  use('tpope/vim-fugitive');
  use('tpope/vim-rhubarb');

  use('tpope/vim-sleuth');  -- Automatic tab expand configuration
  use('tpope/vim-commentary');  -- Comment out blocks of code
  use('tpope/vim-surround');  -- change surrounding elements
end);

-- old init.vim code will slowly be migrated out of this file
vim.cmd("source ~/.config/nvim/legacy.vim");

vim.g.tokyonight_style = 'night';
vim.cmd("colorscheme tokyonight");

-- Coloroize
require('telescope').setup({})

-- Colorize

require('colorizer').setup()

-- Autosave

local autosave = require("autosave")
autosave.setup({
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
local lspconfig = require('lspconfig')
local lspinstall = require('lspinstall')
lspinstall.setup()

lspconfig['jedi_language_server'].setup{}

local servers = lspinstall.installed_servers()
for _, server in pairs(servers) do
  lspconfig[server].setup{}
end

local saga = require('lspsaga')
saga.init_lsp_saga();

local lspkind = require('lspkind');
lspkind.init({})

local compe = require('compe')
compe.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
};

-- NvimTree

vim.g.nvim_tree_show_icons = {
    git = 0,
    folders= 1,
    files = 0,
    folder_arrows = 1,
};

-- Keymaps in vimpeccable

local vimp = require('vimp')

vimp.nnoremap('<leader>ev', ':edit $MYVIMRC<cr>')
vimp.nnoremap('<leader>el', ':edit ~/.config/nvim/init.lua<cr>')
vimp.nnoremap('<leader>sv', ':source $MYVIMRC<cr>')
vimp.nnoremap('<leader>ez', ':edit ~/.zshrc<cr>')
vimp.nnoremap('<leader>es', ':edit ~/.config/sway/config<cr>')
vimp.nnoremap('<leader>et', ':edit ~/.config/kitty/kitty.conf<cr>')

vimp.nnoremap('<c-p>', ':Telescope find_files<cr>')
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
