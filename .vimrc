set nocompatible
filetype off
filetype plugin indent on

" Security
set modelines=0

set autoindent
set smartindent

set noexrc

syntax on
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4
set smarttab autoindent
set showmatch
set laststatus=2

set ruler
set number
set incsearch
set paste
set relativenumber

set virtualedit=all

filetype plugin on
filetype indent on

" Status Displays
set noerrorbells
set visualbell
set t_vb=
set showmatch
set matchtime=5
set listchars=tab:▸\ ,eol:¬

" Text wrap
set wrap
set textwidth=79
set formatoptions=qrn1
set backspace=2

" Status line
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)


" Backups
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap// " swap files
set backup " enable backups

" Leader
let mapleader = ","

" HTML tag closing
inoremap <C-_> <Space><BS><Esc>:call InsertCloseTag()<cr>a

" Clean whitespace
map <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

map <leader>l :set list!

" Syntax stuff
"au BufNewFile,BufRead *.less set filetype=css
"au BufNewFile,BufRead *.less set foldmethod=marker
"au BufNewFile,BufRead *.less set foldmarker={,}
"au BufNewFile,BufRead *.less set nocursorline

" Vim 7.3 (MacPorts) Delete/Backspace Fix
:fixdel

if has("autocmd")
    filetype on
        augroup filetype
          filetype plugin indent on
          autocmd FileType css set smartindent
          autocmd FileType htmldjango set shiftwidth=2
          autocmd FileType html set shiftwidth=2
          autocmd FileType css set shiftwidth=2
          autocmd FileType scss set shiftwidth=2
          autocmd FileType javascript set shiftwidth=2
          autocmd FileType xhtml set shiftwidth=2
          autocmd FileType pde set filetype=java
          autocmd BufNewFile,BufRead *.txt set filetype=human
        augroup END

endif " has("autocmd")

