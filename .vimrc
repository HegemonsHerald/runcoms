" PLUGINS {{{

call plug#begin()

" RUUUUUUST
Plug 'rust-lang/rust.vim'

" HASKEEEEELLLL
Plug 'neovimhaskell/haskell-vim'

" Lisp
" Plug 'kovisoft/slimv'

" Preview substitutions
Plug 'markonm/traces.vim'

" Better file navigation
Plug 'justinmk/vim-dirvish'

" Markdown Syntax an Folding
Plug 'plasticboy/vim-markdown'

" Colorschemes
Plug 'ayu-theme/ayu-vim'
" Plug 'flazz/vim-colorschemes'
" Plug 'lifepillar/vim-colortemplate'

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
set expandtab                       " et    expand tabs to spaces

filetype plugin on                  " load filetype specific plugins
filetype indent on                  " load filetype specific indent files

let g:rustfmt_autosave = 1          " have rust be auto-formatted

" have the markdown plugin add the right kind of folding
let g:vim_markdown_folding_style_pythonic = 1

" }}}

" SYNTAX AND THEMING {{{

syntax on

set termguicolors                   " use gui colors for the terminal (truecolor)

set conceallevel=2                  " cole  syntax elements can be hidden

" make termguicolors work with tmux
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" fix background flickering in kitty
let &t_ut = ""

" use underlining when highlighting Search results
highlight Search term=reverse cterm=underline gui=underline guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE

" let ayucolor='dark'
" colorscheme ayu

colorscheme Eva_Unit-02

" }}}

" MAPPINGS {{{

let mapleader = "\<C-c>" " see :h expr-quote for more on the backslash

" Note: to make multiple mapleaders, simply redefine the mapleader variable right before defining the mappings

" Note: "noremap" means "non-recursive map", ie the expansion will not be further expanded

" NOTE: DO NOT PUT COMMENTS AT THE END OF MAPPING LINES. THEY WILL BE TREATED AS PART OF THE MAPPING

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

" align text relative to text width
nnoremap <Leader><Left>  :left   &textwidth<Cr>
nnoremap <Leader><Right> :right  &textwidth<Cr>
nnoremap <Leader><Down>  :center &textwidth<Cr>

" edit anywhere
nnoremap <Leader>e :call ToggleVirtualEdit()<Cr>

" add line numbers to visually selected range
vnoremap <Leader>N :'<,'> call NumberLines()<Cr>

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
    " set foldcolumn=5
    set foldcolumn=1
  else
    set foldcolumn=0
  endif

endfunc

func! ToggleVirtualEdit()

  if &virtualedit == 'all'
    set virtualedit=
  else
    set virtualedit=all
  endif

  " Print new state
  set virtualedit

endfunc

" Adds line numbers to the provided range using POSIX nl
func! NumberLines() range

  let lineCount = a:lastline - a:firstline + 1
  let width = floor(log10(lineCount)) + 1

  exe printf(" %d,%d ! nl -n rz -s ' ' -w %d ", a:firstline, a:lastline, float2nr(width))

endfunc

" }}}

" FOLDING {{{

" Note: see foldmethod

" automatically save and restore views (those contain data on custom folds)
" Note: the silent! keyword suppresses error messages from these commands
augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave * silent! mkview  " mkview saves the folds in a viewfile in ~/.vim/views/
  autocmd BufWinEnter * silent! loadview  " loadview loads the appropriate viewfile
augroup END

" }}}

" FILETYPE SPECIFIC CONFIGS {{{

autocmd BufRead,BufNewFile *.tex set conceallevel=0

autocmd BufRead,BufNewFile *.lisp set filetype=lisp

autocmd BufRead,BufNewFile *.sls,*.scm set filetype=scheme

autocmd BufRead,BufNewFile *.pl set filetype=prolog

autocmd BufRead,BufNewFile *.java setlocal syntax=java
autocmd BufRead,BufNewFile *.java inoreabbrev <buffer> sysp System.out.println(
autocmd BufRead,BufNewFile *.java inoreabbrev <buffer> sysf System.out.println(String.format(
autocmd BufRead,BufNewFile *.java inoreabbrev <buffer> sysP System.out.print(
autocmd BufRead,BufNewFile *.java inoreabbrev <buffer> sysF System.out.print(String.format(

autocmd BufRead,BufNewFile *.java,*.c setlocal foldmethod=syntax

" }}}

" BIGGER FUNCTIONS {{{

" LatexMathExpand()
"
" The LatexMathExpand function implements abbreviations of common LaTeX
" math-mode macros. Invoking the function changes the current line or visual
" range by replacing the abbreviations with their expansions.
"
" THE ABBREVIATIONS MUST HAVE WHITESPACE BEFORE AND AFTER THEM.
"
" You could use abbrev or map for this, but those will expand immediately.
" LatexMathExpand allows you to write math text with abbreviations, which make
" the text easier to read and write.
"
" There is a special abbreviation for logical variables in the form X_n:
"
"   x7  ->  X_7
"   X3  ->  X_3
"   xm  ->  X_m
"
" Indexes with more than one alphanumeric character won't be expanded.
"
" Example of the abbreviations:
"
"      phi _{i + 7} = bigor ( x1 , not x2 , x2 and x3 ) xor ( x1 and x2 <-> x3 )
"  =>
"      \phi _{i + 7} = \biglor ( X_1 , \lnot X_2 , X_2 \land X_3 ) \xor ( X_1 \land X_2 \leftrightarrow X_3 )
"
func! LatexMathExpand()

  " The e flag suppresses no-match errors

  " Variables
  :s/\v(\s)[Xx]([a-zA-Z0-9])(\s)/\1X_\2\3/ge

  let substitutions = {
        \  '<->':      '\leftrightarrow'
        \, '->':       '\rightarrow'
        \, '<-':       '\leftarrow'
        \, '<=':       '\leq'
        \, '>=':       '\geq'
        \, 'and':      '\land'
        \, 'or':       '\lor'
        \, 'not':      '\lnot'
        \, 'xor':      '\xor'
        \, 'bigand':   '\bigland'
        \, 'bigor':    '\biglor'
        \, 'eqv':      '\eqv'
        \, 'eval':     '\eval'
        \, 'bigeval':  '\bigeval'
        \, 'bigland':  '\bigland'
        \, 'biglor':   '\biglor'
        \, 'bigxor':   '\bigxor'
        \, 'parity':   '\parity'
        \, 'leq':      '\leq'
        \, 'geq':      '\geq'
        \, 'phi':      '\phi'
        \, 'psi':      '\psi'
        \ }

  for key in keys(substitutions)
    " Regex is no-magic ('\V'), so that I only have to escape '\' and '?'
    let match = escape(key, '\?')
    let subst = escape(get(substitutions, key, 'default'), '\?')
    exe ':s/\V\(\s\|\^\)' . match . '\(\s\|\$\)/\1' . subst . '\2/ge'
  endfor

endfunc

noremap <Leader>L :call LatexMathExpand()<Cr>

" }}}

" vim:sts=2:sw=2:et:foldmethod=marker
