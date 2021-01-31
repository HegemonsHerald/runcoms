" PLUGINS {{{

call plug#begin()

" Language Plugins
Plug 'rust-lang/rust.vim'
Plug 'neovimhaskell/haskell-vim'
" Plug 'kovisoft/slimv'
Plug 'plasticboy/vim-markdown'

" Preview substitutions
Plug 'markonm/traces.vim'

" Better file navigation
Plug 'justinmk/vim-dirvish'
Plug 'ddrscott/vim-side-search'

" Window management
Plug 'spolu/dwm.vim'

" Colorschemes and Theming stuff
Plug 'ayu-theme/ayu-vim'
" Plug 'flazz/vim-colorschemes'
" Plug 'lifepillar/vim-colortemplate'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'

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

set modeline                        " ml    execute modelines in files

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
set fillchars=stl:\ ,stlnc:\        " fcs   characters to fill statusline and vertical separators
set fillchars+=fold:\ 

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

set viewoptions=folds               " vop   only save fold data when using :mkview
" I use views to save manual folds, but I want to leave file-specific options up
" to modelines, which are more convenient. Options would be saved by default.
" See FOLDING below.

filetype plugin on                  " load filetype specific plugins
filetype indent on                  " load filetype specific indent files

" }}}

" PLUGINS AND AUTOMATIONS OPTIONS {{{

" Have rust be auto-formatted
let g:rustfmt_autosave = 1

" Have the markdown plugin add the right kind of folding
let g:vim_markdown_folding_style_pythonic = 1

" Highlight Group to use for FocusMode. FocusModeHL is defined as part of the
" Eva_Unit-02 colorscheme.
let g:focusModeHighlightGroup = 'FocusModeHL'

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

" FUNCTIONS {{{

" Toggles the foldcolumn {{{
func! ToggleFDC()

  if &foldcolumn == 0
    " set foldcolumn=5
    set foldcolumn=1
  else
    set foldcolumn=0
  endif

endfunc
" }}}

" Toggles the virtualedit=all option {{{
func! ToggleVirtualEdit()

  if &virtualedit == 'all'
    set virtualedit=
  else
    set virtualedit=all
  endif

  " Print new state
  set virtualedit

endfunc
" }}}

" Toggles scrolloff=999 {{{
func! ToggleTypewriterMode()

  " Set scrolloff for the current buffer
  if &scrolloff == 999
    setlocal scrolloff=-1
  else
    setlocal scrolloff=999
  endif

  " Print new state
  setlocal scrolloff
endfunc
" }}}

" Adds line numbers to the provided range using POSIX nl {{{
func! NumberLines() range

  let lineCount = a:lastline - a:firstline + 1
  let width = floor(log10(lineCount)) + 1

  exe printf(" %d,%d ! nl -n rz -s ' ' -w %d ", a:firstline, a:lastline, float2nr(width))

endfunc
" }}}

" LatexMathExpand() {{{
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
" }}}

" FocusMode {{{
"
" When FocusMode is active the lines above and below the cursor's line are
" highlighted in a single hl-group. Thus only the current line has colored
" syntax highlighting.
"
" FocusMode is set per window. A buffer can have several windows.
"
" The first time FocusMode is activated for any window of the buffer, a
" buffer-local variable counting the number of activated windows,
" b:focusModeActiveWindowsCount, is created. Additionally a buffer-local autocmd
" is added to update the highlighting in all activated windows.
"
" Each activated window gets a window-local variable, w:focusModeWindowState,
" added. When this variable exists, FocusMode is considered active in the
" window.
"
" When FocusMode is stopped in a window, w:focusModeWindowState is removed.
" When FocusMode is stopped for all windows of a buffer, the autocmd and
" b:focusModeActiveWindowsCount are removed as well.
"
" Call FocusModeStart() to begin FocusMode for the current window.
" Call FocusModeStop()  to   end FocusMode for the current window.
"
" You can configure FocusMode with the following variables:
"
"   g:focusModeHighlightGroup     The hl-group used for all but the cursor line.
"   Defaults to Comment.
"
"   g:focusModeRange              The number of lines around the cursor to
"   highlight. Defaults to 0.

func! FocusModeIsActive() " {{{
  return exists('w:focusModeWindowState')
endfunc " }}}

func! FocusModeToggle() " {{{

  if FocusModeIsActive()
    call FocusModeStop()
  else
    call FocusModeStart()
  endif

endfunc " }}}

func! FocusModeStart() " {{{

  if FocusModeIsActive()
    return
  else

    " First activation of FocusMode on any window of this buffer
    if !exists('b:focusModeActiveWindowsCount')
      let b:focusModeActiveWindowsCount = 1
      autocmd CursorMoved,CursorMovedI <buffer> FocusModeStep

    " Subsequent activation of FocusMode on a window of this buffer
    else
      let b:focusModeActiveWindowsCount += 1

    endif

    " Create window state. This activates FocusMode for the current window.
    let w:focusModeWindowState = ''

    " Start highlighting
    FocusModeStep

  endif

endfunc " }}}

func! FocusModeStop() " {{{

  " If FocusMode isn't active, there's nothing to do.
  if FocusModeIsActive()

    if !exists('b:focusModeActiveWindowsCount')
      echo "FocusMode Invalid State"

    else
      let b:focusModeActiveWindowsCount -= 1

      " This window is the last active window
      if b:focusModeActiveWindowsCount == 0
        autocmd! CursorMoved,CursorMovedI <buffer>
        unlet b:focusModeActiveWindowsCount
      endif

    endif

    " Remove previous highlighting
    call matchdelete(w:focusModeWindowState)

    " Delete window state. This ends FocusMode for the current window.
    unlet w:focusModeWindowState

  endif

endfunc " }}}

func! FocusModeStep() " {{{

  if FocusModeIsActive()

    " Remove previous highlighting, if there was previous highlighting
    if w:focusModeWindowState != ''
      call matchdelete(w:focusModeWindowState)
    endif

    " hl-group to use for the non-cursor lines
    let hlGroup = exists('g:focusModeHighlightGroup') ?  g:focusModeHighlightGroup : 'Comment'

    " lines to keep highlighted
    let cursorline = getpos('.')[1]
    let range      = exists('g:focusModeRange') ? g:focusModeRange : 0
    let start      = cursorline - range
    let end        = cursorline + range

    " Set new highlighting
    " \%<23l   Matches above line 23 (lower line number).
    " \%>23l   Matches below line 23 (higher line number).
    let w:focusModeWindowState = matchadd(hlGroup, '\%<' . start . 'l\|\%>' . end . 'l')

  endif

endfunc " }}}

command! FocusModeStep :call FocusModeStep()

" }}}

" GoyoEnter, GoyoLeave {{{
" Add typewriter and FocusMode to Goyo automatically.

func! GoyoEnter()
  setlocal scrolloff=999
  call FocusModeStart()
  norm M
endfunc

func! GoyoLeave()
  setlocal scrolloff=-1
  silent! call FocusModeStop()
endfunc

autocmd User GoyoEnter nested call GoyoEnter()
autocmd User GoyoLeave nested call GoyoLeave()
" }}}

" }}}

" MAPPINGS {{{

let mapleader = "\<C-c>" " see :h expr-quote for more on the backslash

" Note: to make multiple mapleaders, simply redefine the mapleader variable right before defining the mappings

" Note: "noremap" means "non-recursive map", ie the expansion will not be further expanded

" NOTE: DO NOT PUT COMMENTS AT THE END OF MAPPING LINES. THEY WILL BE TREATED AS PART OF THE MAPPING

" toggle highlighting whitespace
nnoremap <Leader>l :set list!<Cr>

" LatexMathExpand()
noremap  <Leader>L :call LatexMathExpand()<Cr>

" toggle foldcolumn
nnoremap <Leader>F :call ToggleFDC()<Cr>

" toggle FocusMode
nnoremap <Leader>f :call FocusModeToggle()<Cr>

" toggle Typewriter mode
nnoremap <Leader>t :call ToggleTypewriterMode()<Cr>

" disable search highlight
nnoremap <Leader>n :noh<Cr>

" add line numbers to visually selected range
vnoremap <Leader>N :'<,'> call NumberLines()<Cr>

" underline current line
nnoremap <Leader>u YpVr-
nnoremap <Leader>U YpVr=

" toggle cursorline, cursorcolumn
nnoremap <Leader>c :set cursorline!<Cr>
nnoremap <Leader>C :set cursorcolumn!<Cr>

" align text relative to text width
nnoremap <Leader><Left>  :left   &textwidth<Cr>
nnoremap <Leader><Right> :right  &textwidth<Cr>
nnoremap <Leader><Down>  :center &textwidth<Cr>

" edit anywhere
nnoremap <Leader>e :call ToggleVirtualEdit()<Cr>

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

" FOLDING {{{

" Note: see foldmethod

" automatically save and restore views (those contain data on custom folds)
" Note: the silent! keyword suppresses error messages from these commands
augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave * silent! mkview    " mkview saves the folds in a viewfile in ~/.vim/views/
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

" vim:sts=2:sw=2:et:foldmethod=marker
