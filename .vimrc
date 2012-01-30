" .vimrc, largely culled form @stevelosh


call pathogen#infect()
syntax on
filetype plugin indent on
set nocompatible

" Basic options {{{
"
set backspace=indent,eol,start
set number
set relativenumber
set undofile
set undoreload=10000

" Resize splits when the window is resized (now that I've got mouse options)
au VimResized * exe "normal! \<c-w>="

" }}}

" Leader {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}

" Convenience mappings -------------------------------------------------------- {{{

" Faster Esc
inoremap jk <esc>
vnoremap jk <esc>


" Quick editing --------------------------------------------------------------- {{{
set pastetoggle=<F2>
vnoremap <silent>y "*y<cr><esc>
nnoremap <leader>ev <C-w>s<C-w>j<C-w>L:e $MYVIMRC<cr>
nnoremap <leader>eq :!hg commit -R ~/Documents/Cabinet/ -m 'Checking in...' <bar> hg push mol<cr><cr>
nnoremap <leader>ep :!prop up<cr><cr> 
nnoremap <leader>es :source $MYVIMRC<cr>
inoremap <tab> <c-x><c-o>
" }}}

" Directional Keys {{{

" It's 2012.
noremap j gj
noremap k gk

" Easy buffer navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l
noremap <leader>g <C-w>v
noremap <leader>q <C-w>q

" Get some mouse action
set mouse=a

" }}}

" Searching {{{

noremap <leader><space> :noh<cr>:call clearmatches()<cr>

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

" }}}

" Backups {{{

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set backup                        " enable backups
set noswapfile

" }}}

" Statusline ----------------------------------------------------------------- {{{

augroup ft_statuslinecolor
    au!

    au InsertEnter * hi StatusLine ctermfg=196 guifg=#FF3145
    au InsertLeave * hi StatusLine ctermfg=130 guifg=#CD5907
augroup END

set statusline=%f    " Path.
set statusline+=%m   " Modified flag.
set statusline+=%r   " Readonly flag.
set statusline+=%w   " Preview window flag.

set statusline+=\    " Space.

set statusline+=%#redbar#                " Highlight the following as a warning.
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()} " Syntastic errors.
set statusline+=%*                           " Reset highlighting.

set statusline+=%=   " Right align.

" File format, encoding and type.  Ex: "(unix/utf-8/python)"
set statusline+=(
set statusline+=%{&ff}                        " Format (unix/DOS).
set statusline+=/
set statusline+=%{strlen(&fenc)?&fenc:&enc}   " Encoding (utf-8).
set statusline+=/
set statusline+=%{&ft}                        " Type (python).
set statusline+=)

" Line and column position and counts.
set statusline+=\ (line\ %l\/%L,\ col\ %03c)
" }}}

