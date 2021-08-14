filetype plugin indent on

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
nnoremap <leader>el :edit ~/.config/nvim/init.lua<cr>
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
nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>

" =========== Fugitive configuration ===========

vnoremap <leader>gb :GBrowse<cr>

" =========== Fzf Configuration ==========

nnoremap <c-p> :Telescope find_files<cr>
nnoremap <c-b> :Telescope buffers<cr>
nnoremap <c-k> :Telescope live_grep<cr>

" =========== Tree Configuration ==========
nnoremap <leader>/ :NvimTreeToggle<cr>
