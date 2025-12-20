let mapleader= " "

" for netrw
nnoremap <leader>cd :Ex<CR>

" window movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" buf move
nnoremap L :bnext<CR>
nnoremap H :bprev<CR>

" Close the current window/split
nnoremap <Leader>wc :close<CR>

" Close (delete) the current buffer without closing the window
nnoremap <Leader>bc :bdelete<CR>
