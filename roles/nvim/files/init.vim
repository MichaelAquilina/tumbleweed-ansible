" Set encoding before setting script encoding
set encoding=utf-8
scriptencoding utf-8

filetype indent on
filetype off
set autoindent
set autoread
set colorcolumn=100
set cursorcolumn
set cursorline
set endofline
set expandtab
set hidden
set history=100
set hlsearch
set inccommand=nosplit " Enables previewing what is being substituted with %s/
set incsearch
set laststatus=2
set list
set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<, " Show whitespace characters
set mouse=a
set nofoldenable
set noswapfile
set nowrap
set number
set shiftwidth=4
set showmatch
set spell spelllang=en_gb
set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors
set tabstop=4
set termguicolors
syntax enable

call plug#begin('~/.vim/plugged')

" Text objects
Plug 'kana/vim-textobj-user'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'kana/vim-textobj-entire'
Plug 'sgur/vim-textobj-parameter'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'

Plug 'christoomey/vim-system-copy'
Plug 'neomake/neomake'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Add syntax highlighting for all popular languages
Plug 'MichaelAquilina/vim-polyglot', {'branch': 'fix_spellcheck_dockerfile'}
Plug 'tpope/vim-markdown'
Plug 'terminalnode/sway-vim-syntax'

" Disable markdown in polyglot to use vim-markdown and enable code block
" highlighting
let g:polyglot_disabled = ['md', 'markdown']
let g:markdown_fenced_languages = ['python', 'html', 'css', 'scss', 'sql', 'javascript', 'go', 'python', 'bash=sh', 'c', 'ruby']
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter' " Shows git changes near line numbers
Plug 'tpope/vim-fugitive' " Add git commands within vim
Plug 'tpope/vim-rhubarb' " Browse code in github
Plug 'tpope/vim-repeat' " Allow plugin commands to be repeatable
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}  " language server
Plug 'Shougo/neosnippet'
Plug 'MichaelAquilina/neosnippet-snippets'
Plug 'challenger-deep-theme/vim'

call plug#end()
filetype plugin indent on    " required!
"
" enable hyperlinks in man pages
runtime 'ftplugin/man.vim'

colorscheme challenger_deep

let g:mapleader=' '

" Reverse the layout to make the FZF list top-down
let $FZF_DEFAULT_OPTS='--layout=reverse'

" Using the custom window creation function
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

" Function to create the custom floating window
function! FloatingFZF()
  " creates a scratch, unlisted, new, empty, unnamed buffer
  " to be used in the floating window
  let buf = nvim_create_buf(v:false, v:true)

  " 90% of the height
  let height = float2nr(&lines * 0.6)
  " 60% of the height
  let width = float2nr(&columns * 0.6)
  " horizontal position (centralized)
  let horizontal = float2nr((&columns - width) / 2)
  " vertical position (one line down of the top)
  let vertical = float2nr((&lines - height) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height
        \ }

  " open the new window, floating, and enter to it
  call nvim_open_win(buf, v:true, opts)
endfunction


" Setup status line
set laststatus=2
set statusline=
set statusline+=%f
set statusline+=%=
set statusline+=\ %l:%c
set statusline+=\ %y
set statusline+=\ %{b:gitbranch}

function! StatuslineMode()
  let l:mode=mode()
  if l:mode==#'n'
    return 'NORMAL'
  elseif l:mode==?'v'
    return 'VISUAL'
  elseif l:mode==#'i'
    return 'INSERT'
  elseif l:mode==#'R'
    return 'REPLACE'
  elseif l:mode==?'s'
    return 'SELECT'
  elseif l:mode==#'t'
    return 'TERMINAL'
  elseif l:mode==#'c'
    return 'COMMAND'
  elseif l:mode==#'!'
    return 'SHELL'
  endif
endfunction

function! StatuslineGitBranch()
  let b:gitbranch=''
  if &modifiable
    lcd %:p:h
    let l:gitrevparse=system('git rev-parse --abbrev-ref HEAD')
    lcd -
    if l:gitrevparse!~?'fatal: not a git repository'
      let b:gitbranch='(  '.substitute(l:gitrevparse, '\n', '', 'g').' ) '
    endif
  endif
endfunction

augroup GetGitBranch
  autocmd!
  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

" Allow opening github enterprise urls
let g:github_enterprise_urls = ['https://git.lystit.com']

" Shortcuts for editing commonly used configs
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>ez :edit ~/.zshrc<cr>
nnoremap <leader>es :edit ~/.config/sway/config<cr>
nnoremap <leader>ew :edit ~/.config/waybar/config<cr>
nnoremap <leader>em :edit ~/.config/mako/config<cr>
nnoremap <leader>et :edit ~/.config/kitty/kitty.conf<cr>

" Quickly move lines up and down
nnoremap - ddp
nnoremap _ ddkP

" NerdTree Shortcuts
nnoremap <leader>/ :NERDTreeToggle<cr>

nnoremap <leader>]  :GitGutterNextHunk<cr>
nnoremap <leader>[  :GitGutterPrevHunk<cr>
nnoremap <leader>+ :GitGutterLineHighlightsToggle<cr>
nnoremap <leader>c :GitGutterUndoHunk<cr>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> rn <Plug>(coc-rename)

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" FZF bindings
nnoremap <c-L> :History:<cr>
nnoremap <c-p> :Files<cr>
nnoremap <c-b> :Buffers<cr>
nnoremap <c-h> :BCommits<cr>
let g:fzf_commits_log_options = '--color=always --format="%C(auto)%h %C(green)%an %C(auto)%s %C(black)%C(bold)%cr"'

" Disable Ex-mode
nnoremap Q <nop>

" Disable stop redraw
nnoremap <c-s> <nop>

" Don't insert odd characters into buffer by mistake
inoremap <c-b> <nop>
inoremap <c-s> <nop>

nnoremap <esc><esc> :let @/ = ""<cr>

nnoremap <c-right> w
nnoremap <c-left> b
nnoremap <c-up> ^
nnoremap <c-down> $

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

nnoremap <leader>, :call CopyRelativePath(0) <cr>
nnoremap <leader>. :call CopyRelativePath(1) <cr>
vnoremap <leader>gb :Gbrowse <cr>
nnoremap <leader>gb v:Gbrowse <cr>
nnoremap <leader>gd :Gdiff <cr>

" Enable word wrapping in text files
augroup WrapLineInMarkdownFile
    autocmd!
    autocmd FileType markdown setlocal wrap lbr
augroup END

augroup vimrc
    autocmd!

    call neomake#configure#automake('nw')

    " Remove extra whitespaces
    autocmd BufWritePre,BufLeave,FocusLost * silent! :%s/\s\+$//e
    " Remove extra blank lines at the end of the file
    autocmd BufWritePre,BufLeave,FocusLost * silent! :%s#\($\n\s*\)\+\%$##

    " Autoreload on external changes
    autocmd BufEnter,FocusGained * :checktime

    " Save on Focus Lost
    autocmd BufLeave,FocusLost * silent! wall
augroup END

if &term =~# '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif
