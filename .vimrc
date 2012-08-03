" .vimrc, largely culled form @stevelosh
"
"
" Hodgepodge of useful things from sjl 

" Preamble {{{
call pathogen#infect()
syntax on
filetype plugin indent on
set nocompatible
"}}}
" Basic options {{{
set encoding=utf8
set backspace=indent,eol,start
set visualbell
set showbreak=↪
set number
set relativenumber
set undofile
set undoreload=10000
set lazyredraw	" Don't redraw mid-execution of something
set laststatus=2  " Always display statusbar
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors
set fillchars=diff:⣿
set ttyfast 
set ruler
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set ttimeout
set notimeout
set nottimeout

" Resize splits when the window is resized (now that I've got mouse options)
au VimResized * exe "normal! \<c-w>="

" }}}
" Leader {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" Bash {{{
set shellcmdflag=-lc
set shell=/bin/bash\ --rcfile\ ~/.bashrc
" }}}
" Convenience Mappings {{{
" Faster Esc
inoremap jk <esc>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Emacs-like bindings in the command line
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Better Completion
set completeopt=longest,menuone,preview

" }}}
" Date {{{
inoremap <leader>da <esc>:r!date +"\%Y-\%m-\%d\%H:\%M:\%S"<cr>$a 
nnoremap <leader>da :r!date +"\%Y-\%m-\%d\%H:\%M:\%S"<cr>$ 
" }}} 
" Colorscheme {{{
syntax on
set background=dark
colorscheme molokai
" }}}
" Quick editing {{{ 
set pastetoggle=<F8>
vnoremap <silent>y "*y<cr><esc>
nnoremap <leader>ev <C-w>s<C-w>j<C-w>L:e $MYVIMRC<cr>
nnoremap <leader>ep :!prop up<cr><cr> 
nnoremap <leader>es :source $MYVIMRC<cr>
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
" Tabs, spaces, wrapping {{{

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set textwidth=80
set formatoptions=qrn1
set colorcolumn=+1

" }}}
" Searching {{{

noremap <leader><space> :noh<cr>:call clearmatches()<cr>

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
nnoremap n nzzzv
nnoremap N Nzzzv

" Center finding searches

" }}}
" Backups {{{

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set backup                        " enable backups
set noswapfile

" }}}
" Shell {{{ 

function! s:ExecuteInShell(command) " {{{
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright vnew ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>:AnsiEsc<CR>'
    silent! execute 'nnoremap <silent> <buffer> q :q<CR>'
    silent! execute 'AnsiEsc'
    echo 'Shell command ' . command . ' executed.'
endfunction " }}}
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <leader>! :Shell 

" }}}
" Statusline {{{  

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
" Folding {{{
set foldlevelstart=0

" Make the current location sane.
nnoremap <c-cr> zvzt

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

set foldmethod=marker
nnoremap <leader>z zMzvzz

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
" Filetype-actions {{{
" Jinja {{{
augroup ft_jinja
    au!
    au BufNewFile,BufRead *.j2 setlocal filetype=jinja
    
" }}}
" HTML {{{
augroup ft_html
	au!
	" Use <localleader>f to fold the current tag.
	au FileType html,jinja,htmldjango nnoremap <buffer> <localleader>f Vatzf
"}}}
" CSS and LessCSS {{{

augroup ft_css
    au!

    au BufNewFile,BufRead *.less setlocal filetype=less

    au Filetype less,css setlocal foldmethod=marker
    au Filetype less,css setlocal foldmarker={,}
    au Filetype less,css setlocal omnifunc=csscomplete#CompleteCSS
    au Filetype less,css setlocal iskeyword+=-

    " Use <localleader>S to sort properties.  Turns this:
    "
    "     p {
    "         width: 200px;
    "         height: 100px;
    "         background: red;
    "
    "         ...
    "     }
    "
    " into this:

    "     p {
    "         background: red;
    "         height: 100px;
    "         width: 200px;
    "
    "         ...
    "     }
    au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

    " Make {<cr> insert a pair of brackets in such a way that the cursor is correctly
    " positioned inside of them AND the following code doesn't get unfolded.
    au BufNewFile,BufRead *.less,*.css inoremap <buffer> {<cr> {}<left><cr><space><space><space><space>.<cr><esc>kA<bs>
augroup END

" }}}
" Arduino {{{

augroup ft_arduino
    au!

    au BufNewFile,BufRead *.ino setlocal filetype=c

augroup END

" }}}
" Processing {{{

augroup ft_processing
    au!

    au BufNewFile,BufRead *.pde setlocal filetype=java

augroup END

" }}}
" NerdTREE {{{
noremap <F2> :NERDTreeToggle<cr>
inoremap <F2> <esc>:NERDTreeToggle<cr>

" Current file, whereverever ye shall be
noremap <leader><F2> :NERDTreeFind<cr>
inoremap <leader><F2> <esc>:NERDTreeFind<cr>

" Show hidden files, please.
let NERDTreeShowHidden=0

" Single click to open directories, double for files
let NERDTreeMouseMode=2

let NERDTreeHighlightCursorLine=1


"}}}"}}}
" Powerline {{{
let Powerline_symbols="fancy"
"}}}
" Supertab {{{

let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabLongestHighlight = 1

"}}}
" Syntastic {{{

let g:syntastic_enable_signs = 1
let g:syntastic_disabled_filetypes = ['html']
let g:syntastic_stl_format = '[%E{%e Errors}%B{, }%W{%w Warnings}]'
let g:cssColorVimDoNotMessMyUpdatetime = 1

" }}}
" CSS Color {{{
let g:cssColorVimDoNotMessMyUpdatetime = 1
"}}}
" Filetype {{{
" Text {{{
    augroup ft_text 
        au!
        au BufNewFile,BufRead *.txt setlocal filetype=text
        au Filetype text setlocal linebreak
        au Filetype text setlocal nolist
        au Filetype text setlocal number
        au Filetype text setlocal nonumber
        au Filetype text setlocal spell spelllang=en_us
    augroup END 
    " Turn off spell where it's annoying. It's usually annoying.
    autocmd BufRead notes.txt setlocal nospell
    autocmd BufRead scratch.txt setlocal nospell

" }}}
" Make {{{
    augroup ft_make 
        au!
        au BufNewFile,BufRead *.mk setlocal filetype=make
        au Filetype text setlocal linebreak
        au Filetype text setlocal nolist
        au Filetype text setlocal number
        au Filetype text setlocal nonumber
    augroup END 

" }}}
" }}}
