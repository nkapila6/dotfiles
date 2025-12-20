let s:plugin_dir = expand('~/.config/vim/plugins')

function! s:ensure(repo)
    let name = split(a:repo, '/')[-1]
    let path = s:plugin_dir . '/' . name

    if !isdirectory(path)
        if !isdirectory(s:plugin_dir)
            call mkdir(s:plugin_dir, 'p')
        endif
        execute '!git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
    endif

    execute 'set runtimepath+=' . fnameescape(path)
endfunction

call s:ensure('ghifarit53/tokyonight-vim')
call s:ensure('morhetz/gruvbox')

call s:ensure('junegunn/fzf')
call s:ensure('junegunn/fzf.vim')

call s:ensure('itchyny/lightline.vim')

call s:ensure('tpope/vim-commentary')

" lsp
call s:ensure('prabirshrestha/vim-lsp')
call s:ensure('mattn/vim-lsp-settings')

" autocomplete
call s:ensure('prabirshrestha/asyncomplete.vim')
call s:ensure('prabirshrestha/asyncomplete-lsp.vim')
call s:ensure('prabirshrestha/asyncomplete-buffer.vim')
call s:ensure('keremc/asyncomplete-clang.vim')

" marks
call s:ensure('yaocccc/vim-showmarks')

" bufferline
call s:ensure('ap/vim-buftabline')

" which key
call s:ensure('liuchengxu/vim-which-key')
" let g:mapleader = "\Space"
" nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>

" surround
call s:ensure('tpope/vim-surround')
