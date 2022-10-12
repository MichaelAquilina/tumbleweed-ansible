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
  use({'kyazdani42/nvim-tree.lua', tag = '1.2.8'});
  use('norcalli/nvim-colorizer.lua');
  use('lukas-reineke/indent-blankline.nvim');
  use({'akinsho/bufferline.nvim', branch = 'main'});

  use('Pocco81/AutoSave.nvim')

  -- Telescope
  use({
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  })
  use({'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

  -- LSP
  use({'neovim/nvim-lspconfig'});
  use('glepnir/lspsaga.nvim');
  use('ray-x/lsp_signature.nvim');
  use('williamboman/nvim-lsp-installer');
  use('hrsh7th/nvim-cmp');
  use('hrsh7th/cmp-nvim-lsp');
  use('L3MON4D3/LuaSnip');
  use('saadparwaiz1/cmp_luasnip');
  use('onsails/lspkind-nvim');

  -- Treesitter
  use({'nvim-treesitter/nvim-treesitter'});
  use({'nvim-treesitter/nvim-treesitter-textobjects'});
  use({'lewis6991/spellsitter.nvim'});
  use({'windwp/nvim-ts-autotag'});

  -- Git
  use('airblade/vim-gitgutter');
  use('tpope/vim-fugitive');
  use('tpope/vim-rhubarb');

  use('tpope/vim-sleuth');  -- Automatic tab expand configuration
  use('tpope/vim-commentary');  -- Comment out blocks of code
  use('kylechui/nvim-surround');  -- change surrounding elements
end);


vim.g.tokyonight_style = 'night';
vim.cmd("colorscheme tokyonight");

-- Bufferline

require("bufferline").setup{}

-- Spellsitter
local spellsitter = require('spellsitter');
spellsitter.setup({
    enable = true
});
vim.o.spell = true;

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
treesitter.setup({
  autotag = { enable = true },
  ensure_installed = "all",
  highlight = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
})

-- Lsp configuration

local cmp = require('cmp')
cmp.setup({
 snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
  end,
 },

 mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
 }),
 sources = cmp.config.sources({
  { name = 'nvim_lsp' }
 })
});

local cmp_nvim_lsp = require('cmp_nvim_lsp')
local lsp_installer = require('nvim-lsp-installer')

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
lsp_installer.on_server_ready(
  function (server) server:setup { capabilities = capabilities }
end)

local saga = require('lspsaga')
saga.init_lsp_saga({
  code_action_prompt = {enable = false}
});

local lspkind = require('lspkind');
lspkind.init({})

local lspconfig = require('lspconfig')
lspconfig.pylsp.setup {
  cmd = {"pylsp"},
  filetypes = {"python"},
  settings = {
    pylsp = {
      configurationSources = {"flake8"},
      plugins = {
        jedi_completion = {enabled = true},
        jedi_hover = {enabled = true},
        jedi_references = {enabled = true},
        jedi_signature_help = {enabled = true},
        jedi_symbols = {enabled = true, all_scopes = true},
        pycodestyle = {enabled = false},
        flake8 = {
          enabled = true,
          ignore = {},
          maxLineLength = 160
        },
        mypy = {enabled = false},
        isort = {enabled = false},
        yapf = {enabled = false},
        pylint = {enabled = false},
        pydocstyle = {enabled = false},
        mccabe = {enabled = false},
        preload = {enabled = false},
        rope_completion = {enabled = false}
      }
    }
  },
  on_attach = on_attach
}


-- NvimTree

vim.g.nvim_tree_ignore = { '.git' }
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_show_icons = {
    git = 0,
    folders= 1,
    files = 0,
    folder_arrows = 1,
};

vim.keymap.set('n', '<leader>ev', ':edit $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>el', ':edit ~/.config/nvim/init.lua<cr>')
vim.keymap.set('n', '<leader>sv', ':source $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>ez', ':edit ~/.zshrc<cr>')
vim.keymap.set('n', '<leader>es', ':edit ~/.config/sway/config<cr>')
vim.keymap.set('n', '<leader>et', ':edit ~/.config/kitty/kitty.conf<cr>')
vim.keymap.set('n', '<leader>d', ':lua vim.diagnostic.open_float()<cr>')

vim.keymap.set('n', '<c-p>', ':Telescope find_files find_command=rg,--ignore,-g,!.git/,--hidden,--files<cr>')
vim.keymap.set('n', '<c-b>', ':Telescope buffers<cr>')
vim.keymap.set('n', '<c-k>', ':Telescope live_grep<cr>')

vim.keymap.set('v', 'cp', '"+y')
vim.keymap.set('n', 'vp', '"+p')

vim.keymap.set('n', 'Q', '<nop>') -- Disable Ex mode
vim.keymap.set('n', '<c-s>', '<nop>') -- Disable stop redraw

vim.keymap.set('n', '<esc>',':let @/=""<cr>') -- Cancel current search

-- Quickly move lines up and down
vim.keymap.set('n', '-', 'ddp')
vim.keymap.set('n', '_', 'ddkP')

vim.keymap.set('n', '<leader>,', ':call CopyRelativePath(0)<cr>')
vim.keymap.set('n', '<leader>.', ':call CopyRelativePath(1)<cr>')

vim.keymap.set('n', '<leader>]', '<Plug>(GitGutterNextHunk)')
vim.keymap.set('n', '<leader>[', '<Plug>(GitGutterPrevHunk)')

vim.keymap.set('n', 'gs', ':Lspsaga signature_help<CR>')
vim.keymap.set('n', 'K', ':Lspsaga hover_doc<CR>')
vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'ca', ':lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', 'cd', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')

vim.keymap.set('v', '<leader>gb', ':GBrowse<cr>')

vim.keymap.set('n', '<leader>/', ':NvimTreeToggle<cr>')

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
