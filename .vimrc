" .vimrc
" Author: Steve Losh <steve@stevelosh.com>
" Source: http://bitbucket.org/sjl/dotfiles/src/tip/vim/
"
" This file changes a lot.  I'll try to document pieces of it whenever I have
" a few minutes to kill.

" Training Mappings -------------------------------------------------------------------- {{{

inoremap <esc> <nop>

" }}}
" Quick Bindings -------------------------------------------------------------------- {{{


" }}}
" Preamble -------------------------------------------------------------------- {{{

filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on
set nocompatible

" }}}
" Basic options --------------------------------------------------------------- {{{
set shellcmdflag=-ic
set encoding=utf-8
set modelines=0
set autoindent
set showmode
set showcmd
set hidden
set visualbell
"set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set number
set relativenumber
set laststatus=2
set history=1000
set undofile
set undoreload=10000
set cpoptions+=J
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set shell=/bin/bash
set lazyredraw
set matchtime=3
set showbreak=↪
set splitbelow
set splitright
set fillchars=diff:\ 
set ttimeout
set notimeout
set nottimeout
set autowrite
set shiftround
set dictionary=/usr/share/dict/words


" Save when losing focus
au FocusLost * :wa

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" Tabs, spaces, wrapping {{{

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set textwidth=85
set formatoptions=qrn1

" }}}
" Backups {{{

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set backup                        " enable backups

" }}}
" Leader {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" Color scheme {{{

syntax on
set background=dark
colorscheme molokai

" }}}

" }}}
" Status line ----------------------------------------------------------------- {{{

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
" Searching and movement ------------------------------------------------------ {{{

" Use sane regexes.
" "nnoremap / /\v
" "vnoremap / /\v


set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

set virtualedit+=block

map <tab> %

" Made D behave
nnoremap D d$

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Don't move on *
nnoremap * *<c-o>

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L $

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Ack for the last search.
nnoremap <silent> <leader>? :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

" Fix linewise visual selection of various text objects
nnoremap VV V
nnoremap Vit vitVkoj
nnoremap Vat vatV
nnoremap Vab vabV
nnoremap VaB vaBV


" Directional Keys {{{

" It's 2011.
noremap j gj
noremap k gk

" Easy buffer navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l
noremap <leader>g <C-w>v

" }}}



" Folding --------------------------------------------------------------------- {{{

set foldlevelstart=0

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

" Use ,z to "focus" the current fold.
nnoremap <leader>z zMzvzz

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()
" }}}
" Quick editing --------------------------------------------------------------- {{{

nnoremap <leader>ev <C-w>s<C-w>j<C-w>L:e $MYVIMRC<cr>
nnoremap <leader>eq :!hg commit ~/Documents/Cabinet/ -m 'Checking in...' <bar> hg push mol<cr><cr>
nnoremap <leader>ep :!prop up<cr><cr> 
nnoremap <leader>es :source $MYVIMRC<cr>
"nnoremap <leader>es <C-w>s<C-w>j<C-w>L:e ~/.vim/snippets/<cr>
nnoremap <leader>eo <C-w>s<C-w>j<C-w>L:e ~/Dropbox/Org<cr>4j
nnoremap <leader>eh <C-w>s<C-w>j<C-w>L:e ~/.hgrc<cr>
nnoremap <leader>em <C-w>s<C-w>j<C-w>L:e ~/.mutt/muttrc<cr>
nnoremap <leader>ez <C-w>s<C-w>j<C-w>L:e ~/lib/dotfiles/zsh<cr>4j
nnoremap <leader>ek <C-w>s<C-w>j<C-w>L:e ~/lib/dotfiles/keymando/keymandorc.rb<cr>

" }}}
" Convenience mappings -------------------------------------------------------- {{{

" Clean whitespace
map <leader>W  :%s/\s\+$//<cr>:let @/=''<CR>

" Dammit, Slimv
map <leader>WW :%s/\s\+$//<cr>:let @/=''<CR>

" Change case
nnoremap <C-u> gUiw
inoremap <C-u> <esc>gUiwea

" Substitute
nnoremap <leader>s :%s//<left>

" Diffoff
nnoremap <leader>D :diffoff!<cr>

" Yankring
nnoremap <silent> <F6> :YRShow<cr>

" Formatting, TextMate-style
nnoremap Q gqip

" Easier linewise reselection
nnoremap <leader>v V`]


" Align text
nnoremap <leader>Al :left<cr>
nnoremap <leader>Ac :center<cr>
nnoremap <leader>Ar :right<cr>
vnoremap <leader>Al :left<cr>
vnoremap <leader>Ac :center<cr>
vnoremap <leader>Ar :right<cr>

" Faster Esc
inoremap jk <esc>

" Cmdheight switching
nnoremap <leader>1 :set cmdheight=1<cr>
nnoremap <leader>2 :set cmdheight=2<cr>

" Marks and Quotes
noremap ' `
noremap æ '
noremap ` <C-^>

" Insert Mode Completion {{{

inoremap <c-l> <c-x><c-l>
inoremap <c-f> <c-x><c-f>

" }}}

" }}}
" Colors ----------------------------------------------------------------------- {{{
hi normal   ctermfg=white  ctermbg=black guifg=white  guibg=black
hi nontext  ctermfg=blue   ctermbg=black guifg=blue   guibg=black
" }}}

