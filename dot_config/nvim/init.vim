lua require 'init'
set number
set relativenumber
set tabstop=8 softtabstop=0 shiftwidth=4 expandtab smarttab
set autoindent
set modeline
set nocompatible
filetype plugin on
syntax on
let g:python_host_prog  = '/usr/bin/python2'
" VimWiki Syntax
let g:vimwiki_list = [{'path': '~/vimwiki/',
                     \ 'syntax': 'markdown', 'ext': '.md'}]

"let g:wiki_root = '~/vimwiki'

" Sidebar
let g:netrw_banner = 0
let g:netrw_liststyle = 1
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

" Word wrap without line breaks
set wrap
set linebreak
set nolist  " list disables linebreak


" Transparent editing of gpg encrypted files.
augroup encrypted
au!
" First make sure nothing is written to ~/.viminfo while editing
" an encrypted file.
autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
" We don't want a swap file, as it writes unencrypted data to disk
autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
" Switch to binary mode to read the encrypted file
autocmd BufReadPre,FileReadPre      *.gpg set bin
autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPre,FileReadPre      *.gpg let shsave=&sh
autocmd BufReadPre,FileReadPre      *.gpg let &sh='sh'
autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt --default-recipient-self 2> /dev/null
autocmd BufReadPost,FileReadPost    *.gpg let &sh=shsave
" Switch to normal mode for editing
autocmd BufReadPost,FileReadPost    *.gpg set nobin
autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
" Convert all text to encrypted text before writing
autocmd BufWritePre,FileWritePre    *.gpg set bin
autocmd BufWritePre,FileWritePre    *.gpg let shsave=&sh
autocmd BufWritePre,FileWritePre    *.gpg let &sh='sh'
autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --encrypt --default-recipient-self 2>/dev/null
autocmd BufWritePre,FileWritePre    *.gpg let &sh=shsave
" Undo the encryption so we are back in the normal text, directly
" after the file has been written.
autocmd BufWritePost,FileWritePost  *.gpg silent u
autocmd BufWritePost,FileWritePost  *.gpg set nobin
augroup END

" vim-ledger
au BufNewFile,BufRead *.ldg,*.ledger setf ledger | comp ledger
au FileType ledger noremap { ?^\d<CR>
au FileType ledger noremap } /^\d<CR>
" let g:ledger_bin = '/usr/bin/hledger'
let g:ledger_is_hledger = 1
let g:ledger_maxwidth = 80
let g:ledger_fillstring = '    -'
let g:ledger_detailed_first = 1
let g:ledger_fold_blanks = 0
let g:ledger_date_format = '%Y-%m-%d'
set nowrap
noremap <silent><buffer> <F5> :call ledger#transaction_state_toggle(line('.'), '!* ')<CR>
let g:ledger_maxwidth = 120
let g:ledger_fold_blanks = 1
function LedgerSort()
    :%! hledger -f - print
    :%LedgerAlign
    :normal Gdd
endfunction
command LedgerSort call LedgerSort()
noremap <silent><buffer> <F6> :LedgerSort<CR>

" vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/goyo.vim'
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'
Plug 'ledger/vim-ledger'
Plug 'vimwiki/vimwiki'
"Plug 'lervag/wiki.vim'
Plug 'vim-syntastic/syntastic'
Plug 'ap/vim-css-color'
Plug 'glacambre/firenvim'
Plug 'tools-life/taskwiki'
"Plug 'blindFS/vim-taskwarrior'
Plug 'alx741/vinfo'
Plug 'sirjofri/vim-biblereader'
call plug#end()

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
