" PLUGINS {{{

call plug#begin()

" RUUUUUUST and HASKEEEEELLLL and LIIIIIISSSSSSP
Plug 'rust-lang/rust.vim'
Plug 'neovimhaskell/haskell-vim'
" Plug 'kovisoft/slimv'

" Tiny things
Plug 'markonm/traces.vim'
Plug 'justinmk/vim-dirvish'

" Colorschemes
Plug 'flazz/vim-colorschemes'
Plug 'ayu-theme/ayu-vim'

" My things
" Plug 'hegemonsherald/vim-codegen'
Plug 'hegemonsherald/vim-dlx_syntax'

call plug#end()

" load filetype specific plugin and indent files
" filetype plugin indent on

" }}}

" LOAD MY CUSTOM STUFF {{{
" These files are in ~/.vim/after
" runtime functionals.vim
" runtime colorschemes.vim

" }}}

" SYNTAX AND THEMING {{{

" use underlining when highlighting Search results
highlight Search term=reverse cterm=underline gui=underline guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE

colorscheme ayu

" }}}

" SET BASIC OPTIONS {{{

" Note: Options may be global or local to a buffer or both. In case of both, use
" :setlocal to only set locally. The following are globally set options.

set nocompatible                    " nocp  don't be vi-compatible

set backspace+=start,eol,indent     " bs    allow backspacing over the position, where insert mode was started; end-of-lines; autoindent's indentation

set number                          " nu
set relativenumber                  " rnu
set ruler                           " ru    show cursor position on status line

set showcmd                         " sc    show commands on status-line
set wildmenu                        " wmnu  show a menu for command line completion

set hlsearch                        " hls   use :noh to hide highlights
set incsearch                       " is    highlight searches incrementally
set ignorecase                      " ic
set smartcase                       " scs

set matchpairs+=<:>                 " mps   add brackets to matching symbols
set listchars=tab:»·,trail:\░,      " lcs   characters for whitespace listing; alternatively use ░ for trail
set nolist                          "       disable whitespace listing

set autowrite                       " aw    write on commands, that jump the arglist

set autoread                        " ar    reread a file, if it changed

set foldmethod=manual               " fdm   don't auto create folds

set textwidth=80                    " tw
set nowrap                          "       don't wrap overlong lines
set colorcolumn=+0                  " cc    highlight the column of textwidth
set cursorline                      " cul   see also cursorcolumn, cuc

set autoindent                      " ai
set smartindent                     " si
set smarttab                        " sta   make use of sts and sw for <tab>-insertion
set tabstop=8                       " ts    display <tab>-characters as 8 spaces
set softtabstop=2                   " sts   insert 3 spaces, when pressing <tab>
set shiftwidth=2                    " sw    use 3 spaces for (auto)indenting

set termguicolors                   " use gui colors for the terminal (truecolor)

syntax on

filetype plugin on                  " load filetype specific plugins
filetype indent on                  " load filetype specific indent files

" make termguicolors work with tmux
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" fix background flickering in kitty
let &t_ut = ""

let g:rustfmt_autosave = 1          " have rust be auto-formatted

" }}}

" MAPPINGS {{{

let mapleader = "\<C-c>" " see :h expr-quote for more on the backslash
" Note: to make multiple mapleaders, simply redefine the mapleader variable right before defining the mappings

" NOTE: DO NOT PUT COMMENTS AT THE END OF MAPPING LINES. THEY WILL BE TREATED AS PART OF THE MAPPING

" Note: "noremap" means "non-recursive map", ie the expansion will not be further expanded

" toggle showing whitespace
nnoremap <Leader>l :set list!<Cr>

" toggle foldcolumn
nnoremap <Leader>f :call ToggleFDC()<Cr>

" disable search highlight
nnoremap <Leader>n :noh<Cr>

" underline current line
nnoremap <Leader>u YpVr-

" toggle cursorline, cursorline
nnoremap <Leader>c :set cursorline!<Cr>
nnoremap <Leader>C :set cursorcolumn!<Cr>

" edit anywhere
nnoremap <Leader>e :set virtualedit=all<Cr>
nnoremap <Leader>E :set virtualedit=<Cr>

" better motions for :set wrap
nnoremap j gj
nnoremap k gk

" substitution mappings
noremap  s/ :s/\v/g<Left><Left>
nnoremap s% :%s/\v/g<Left><Left>
nnoremap S  0D

" indentation mappings
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >>
vnoremap <S-Tab> <<

" }}}

" BASIC FUNCTIONS {{{

" Toggles the foldcolumn
func! ToggleFDC()

  if &foldcolumn == 0
    set foldcolumn=5
  else
    set foldcolumn=0
  endif

endfunc

" }}}

" FOLDING {{{

" automatically save and restore views (those contain data on custom folds)
" note: the silent! keyword suppresses error messages from these commands
augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave * silent! mkview  " mkview saves the folds in a viewfile in ~/.vim/views/
  autocmd BufWinEnter * silent! loadview  " loadview loads the appropriate viewfile
augroup END

" }}}

" FILETYPE SPECIFIC CONFIGS {{{

autocmd BufRead,BufNewFile *.lisp set filetype=lisp

autocmd BufRead,BufNewFile *.sls,*.scm set filetype=scheme

autocmd BufRead,BufNewFile *.hs set et sts=2 sw=2

autocmd BufRead,BufNewFile *.pl set filetype=prolog

autocmd BufRead,BufNewFile *.java,*.c setlocal foldmethod=java

" }}}

" vim:sts=2:sw=2:et:foldmethod=marker
