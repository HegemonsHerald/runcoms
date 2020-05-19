" PLUGINS

call plug#begin()

" RUUUUUUST and HASKEEEEELLLL and LIIIIIISSSSSSP
Plug 'rust-lang/rust.vim'
Plug 'neovimhaskell/haskell-vim'
" Plug 'kovisoft/slimv'

" Tiny things
Plug 'markonm/traces.vim'
Plug 'justinmk/vim-dirvish'
Plug 'https://github.com/vifm/vifm.vim'

" Colorschemes
Plug 'flazz/vim-colorschemes'
Plug 'ayu-theme/ayu-vim'

" My things
" Plug 'hegemonsherald/vim-codegen'
Plug 'hegemonsherald/vim-dlx_syntax'

call plug#end()

" load filetype specific plugin and indent files
" filetype plugin indent on


" LOAD MY CUSTOM STUFF
" These files are in ~/.vim/after
runtime functionals.vim
runtime colorschemes.vim


" SYNTAX AND THEMING

" use underlining when highlighting Search results
highlight Search term=reverse cterm=underline gui=underline guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE


" SET BASIC OPTIONS
set number			" nu
set relativenumber		" rnu
set hlsearch			" hls; use :noh to hide highlights
set incsearch			" highlight searches incrementally
set ignorecase			" ignore case in regex searches
set smartcase			" only match case sensitively, if search pattern contains upper case letter; needs ignorecase to function
set autowrite			" aw
set matchpairs+=<:>		" brackets to matching symbols
set showcmd			" shows commands on status-line, is on by default
set ruler			" ru, is on by default
set listchars=tab:»·,trail:\░,	" lcs, characters for whitespace listing; alternatively use ░ for trail
set nolist			" disable whitespace listing
set autoread			" ar, makes vim reread a file, if it changed
set backspace+=start,eol,indent	" allow backspacing over the position, where insert mode was started; end-of-lines; autoindent's indentation
set autoindent
set smartindent
set smarttab			" make use of sts and sw for <tab>-insertion
set nowrap
set foldmethod=manual
set colorcolumn=+0 		" cc, highlight the column to the right of textwidth
set wildmenu			" wmnu, menu for command line completion
set cursorline			" cul, see also cursorcolumn, cuc
set textwidth=80		" tw
syntax on
filetype plugin on		" load filetype specific plugins

set sts=3
set sw=3

" Fixes for weird color conditions

set termguicolors		" make use of gui colors for the terminal <-- truecolor support

" These two make termguicolors work with tmux
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Kitty Terminal fix background flickering
let &t_ut = ""

" set guicursor=


" MAPPINGS
let mapleader = "\<C-j>" " see :h expr-quote for more on the backslash
" Note: to make multiple mapleaders, simply redefine the mapleader variable right before defining the mappings

nnoremap <Leader>l :set list!<Cr>	  " toggle list option
nnoremap <Leader>f :call ToggleFDC()<Cr>  " toggle foldcolumn
nnoremap <Leader>n :noh<Cr>		  " disable search highlight
nnoremap <Leader>c :set cursorline!<Cr>	  " toggle cursorline
nnoremap <Leader>u YpVr-		  " underline current line

" better motions for :set wrap
nnoremap j gj
nnoremap k gk

" substitution mappings
noremap s/	:s/\v/g<Left><Left>
nnoremap s%	:%s/\v/g<Left><Left>
nnoremap S	0D

" indentation mappings
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >>
vnoremap <S-Tab> <<


" BASIC FUNCTIONS

" Toggles the foldcolumn
func! ToggleFDC()

  if &foldcolumn == 0
    set foldcolumn=5
  else
    set foldcolumn=0
  endif

endfunc


" FOLDING

" automatically save and restore views (those contain data on custom folds)
" note: the silent! keyword suppresses error messages from these commands
augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave * silent! mkview  " mkview saves the folds in a viewfile in ~/.vim/views/
  autocmd BufWinEnter * silent! loadview  " loadview loads the appropriate viewfile
augroup END


" FILETYPE SPECIFIC CONFIGS

augroup filetype_lisp

  autocmd BufRead,BufNewFile *.lisp set filetype=lisp

  " In case the auto-formatting isn't enough =)

augroup END

autocmd BufRead,BufNewFile *.java set sw=8

autocmd BufRead,BufNewFile *.sls,*.scm set filetype=scheme

autocmd BufRead,BufNewFile *.hs set et sts=2 sw=2

autocmd BufRead,BufNewFile *.pl set filetype=prolog


" vim:sts=2:sw=2:noet
