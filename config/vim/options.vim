set number
set relativenumber

filetype plugin indent on
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smartindent

set backspace=indent,eol,start

syntax on

set mouse=a

" marks
set signcolumn=yes
hi Marks ctermfg=80
let g:mark_ns_id = 9898
let g:mark_priority = 999

" auto reindent
autocmd BufWritePre * normal! gg=G
