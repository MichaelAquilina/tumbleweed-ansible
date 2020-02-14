set termguicolors
set t_Co=256 " explicitly use 256 colors

call plug#begin()

" ========== GUI and User Interface ==========
Plug 'MichaelAquilina/vim-nightfly-guicolors'  " has some tweaks

" ========= Syntax Highlighting ==========
Plug 'terminalnode/sway-vim-syntax'
Plug 'sheerun/vim-polyglot'

" ========== Text Objects ==========
Plug 'kana/vim-textobj-user'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'sgur/vim-textobj-parameter'

" ========== Functionality ==========
Plug 'junegunn/fzf', {'do': './install --bin'}
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'

" ========== Git ===========
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

call plug#end()

" =========== General Configuration ==========

colorscheme nightfly

let g:mapleader=' '

filetype plugin indent on
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

" Show whitespace
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<,

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

" Shortcuts for copying and pasting to system clipboard
vnoremap cp "+y
vnoremap vp "+p

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

" =========== Fzf Configuration ==========

nnoremap <c-p> :Files<cr>
nnoremap <c-b> :Buffers<cr>
nnoremap <c-k> :Rg<cr>

" =========== CoC Configuration ==========
nmap <silent> gd <Plug>(coc-definition)
let g:coc_global_extensions = [
	\'coc-python',
	\'coc-json',
	\'coc-yaml',
	\]

" =========== NERDTree Configuration ==========
nnoremap <leader>/ :NERDTreeToggle<cr>
