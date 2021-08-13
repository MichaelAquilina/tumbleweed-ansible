set termguicolors
set t_Co=256 " explicitly use 256 colors

call plug#begin()

" ========== Tresitter support ==========
Plug 'nvim-treesitter/nvim-treesitter', {'branch': '0.5-compat'}

" ========== GUI and User Interface ==========
Plug 'bluz71/vim-nightfly-guicolors'  " has some tweaks
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" ========= Syntax Highlighting ==========
Plug 'sheerun/vim-polyglot'

" ========== Text Objects ==========
Plug 'kana/vim-textobj-user'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'sgur/vim-textobj-parameter'

" ========== Tree View ===========
Plug 'kyazdani42/nvim-tree.lua'

" ========== LSP functionality ========
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'hrsh7th/nvim-compe'
Plug 'onsails/lspkind-nvim'

" ========== Functionality ==========
Plug 'norcalli/nvim-colorizer.lua'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }  }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'  " Automatic tab expand configuration
Plug 'tpope/vim-commentary'  " Comment out blocks of code
Plug 'tpope/vim-surround'  " change surrounding elements

" ========== Git ===========
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

call plug#end()

lua <<EOF
local treesitter = require('nvim-treesitter.configs')
treesitter.setup {
    ensure_installed = "all",
    highlight = {
      enable = true
    }
}

local lspconfig = require('lspconfig')
local lspinstall = require('lspinstall')
lspinstall.setup()

lspconfig['jedi_language_server'].setup{}

local servers = lspinstall.installed_servers()
for _, server in pairs(servers) do
  lspconfig[server].setup{}
end

local saga = require('lspsaga')
saga.init_lsp_saga()

-- local lsp_signature = require('lsp_signature')
-- lsp_signature.setup()

require('lspkind').init({
    -- enables text annotations
    --
    -- default: true
    with_text = true,

    -- default symbol map
    -- can be either 'default' or
    -- 'codicons' for codicon preset (requires vscode-codicons font installed)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = ""
    },
})
EOF

" =========== General Configuration ==========

let g:tokyonight_style = 'night'
colorscheme tokyonight

let g:mapleader=' '

filetype plugin indent on
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set encoding=utf-8
set emoji
set inccommand=nosplit  " Enable previewing of %s//
set mouse=a
set nowrap
set number
set hidden
set nobackup
set nowritebackup
set noswapfile
set cursorline
set cursorcolumn

" Enable spellchecking
set spell spelllang=en_gb

" Show whitespace
set list

" Python configuration
let g:python_host_prog = expand('/usr/bin/python')
let g:python3_host_prog = expand('/usr/bin/python3')

" ============ Auto Commands ==========
augroup vimrc
    autocmd!

    " Remove extra whitespaces
    autocmd BufWritePre,BufLeave,FocusLost * silent! :%s/\s\+$//e
    " Remove extra blank lines at the end of the file
    autocmd BufWritePre,BufLeave,FocusLost * silent! :%s#\($\n\s*\)\+\%$##

    " Autoreload on external changes
    autocmd BufEnter,FocusGained * :checktime

    " Save on Focus Lost
    autocmd BufLeave,FocusLost * silent! wall
augroup END

augroup TextSettings
    autocmd!

    autocmd FileType markdown,rst,text set wrap linebreak
augroup END

" ========== Custom Functions ==========

" Copy the relative path + row number to the clipboard
function! CopyRelativePath(linenumber)
    if a:linenumber
        echom 'Copied relative path to clipboard (with line number)'
        let @+ = @% . ':' . line('.')
    else
        echom 'Copied relative path to clipboard'
        let @+ = @%
    endif
endfunction

" ========== Custom Mappings ==========

nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ez :edit ~/.zshrc<cr>
nnoremap <leader>es :edit ~/.config/sway/config<cr>
nnoremap <leader>et :edit ~/.config/kitty/kitty.conf<cr>

" Shortcuts for copying and pasting to system clipboard
vnoremap cp "+y
nnoremap vp "+p

" Disable Ex-mode
nnoremap Q <nop>
" Disable stop redraw
nnoremap <c-s> <nop>

" Cancel current search
nnoremap <esc> :let @/=""<cr>

" Quickly move lines up and down
nnoremap - ddp
nnoremap _ ddkP

nnoremap <leader>, :call CopyRelativePath(0)<cr>
nnoremap <leader>. :call CopyRelativePath(1)<cr>

" =========== gitgutter configuration ==========
nmap <leader>] <Plug>(GitGutterNextHunk)
nmap <leader>[ <Plug>(GitGutterPrevHunk)

" =========== LSP configuration =========
nnoremap <silent> gs :Lspsaga signature_help<CR>
nnoremap <silent> K :Lspsaga hover_doc<CR>

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true
let g:compe.source.luasnip = v:true
let g:compe.source.emoji = v:true

" =========== Fugitive configuration ===========

vnoremap <leader>gb :GBrowse<cr>

" =========== Fzf Configuration ==========

nnoremap <c-p> :Files<cr>
nnoremap <c-b> :Buffers<cr>
nnoremap <c-k> :Rg<cr>

" Customize the colors of type hints
hi CocHintSign cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=grey35 guibg=NONE

" =========== Tree Configuration ==========
nnoremap <leader>/ :NvimTreeToggle<cr>

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_show_icons = {
    \ 'git': 0,
    \ 'folders': 1,
    \ 'files': 0,
    \ 'folder_arrows': 1,
    \ }
