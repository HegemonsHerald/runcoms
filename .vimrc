" Vundle ===================================================================
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'felixhummel/setcolors.vim'

" RUUUUUUST and HASKEEEEELLLL and LIIIIIISSSSSSP
Plugin 'rust-lang/rust.vim'
Plugin 'neovimhaskell/haskell-vim'
" Plugin 'kovisoft/slimv'

" More advanced autocompletion
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'Shougo/deoplete.nvim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh'
  \ }

" Tiny things
Plugin 'terryma/vim-multiple-cursors'
Plugin 'markonm/traces.vim'
Plugin 'flazz/vim-colorschemes'
" Plugin 'scrooloose/nerdcommenter'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" My things
Plugin 'hegemonsherald/vim-codegen'
Plugin 'hegemonsherald/vim-dlx_syntax'

" Language Server
Plugin 'autozimu/LanguageClient-neovim'

call vundle#end()
filetype plugin indent on

" Brief help
" see :h vundle for more details or wiki for FAQ

" Put your non-Plugin stuff after this line ================================


" LOAD MY CUSTOM STUFF
" These files are in ~/.vim/after
runtime functionals.vim
runtime colorschemes.vim


" LAGUAGE CLIENT NEOVIM
set hidden
let g:LanguageClient_serverCommands = {
      \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
      \ }


" SYNTAX AND THEMING
syntax on

" color Monokai
" highlight Normal ctermbg=none
" highlight NonText ctermbg=none

" use underlining when highlighting Search results
highlight Search term=reverse cterm=underline gui=underline guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE


" SET BASIC OPTIONS
set number			" nu
set relativenumber		" rnu
set hlsearch			" hls; use :noh to hide highlights
set incsearch			" highlight searches incrementally
set ignorecase			" ignore case in search
set smartcase			" only match case sensitively, if search pattern contains upper case letter; needs ignorecase to function
set autowrite			" aw
set matchpairs+=<:>		" brackets to matching symbols
set showcmd			" shows commands on status-line, is on by default
set ruler			" ru, is on by default
set listchars=tab:»·,trail:\ ,	" lcs, characters for whitespace listing; alternatively use ░ for trail
set nolist			" disable whitespace listing
set autoread			" ar, makes vim reread a file, if it changed
set backspace+=start,eol,indent	" allow backspacing over the position, where insert mode was started; end-of-lines; autoindent's indentation
set autoindent
set smartindent
set smarttab			" make use of sts and sw for <tab>-insertion
set nowrap
set foldmethod=manual
set colorcolumn=+2		" cc, highlight the column to the right of textwidth
set wildmenu			" wmnu, menu for command line completion
set cursorline			" cul, cursorcolumn, cuc
filetype plugin on

" set guicursor=


" DEOPLETE CONFIG
" Note: the dependancy nvim-yarp of this, requires pynvim to be installed
" (pip3 install pynvim)
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
      \ 'auto_complete': v:false,
      \ })

" Make it select the first item from the menu
set completeopt=menu,noinsert

call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])

" For some reason this makes it select the first entry of the menu...?
set completeopt+=noinsert

" Map deoplete to CTRL-N
inoremap <C-n> <C-r>=Deoplete_helper()<Cr>

func! Deoplete_helper()
  return deoplete#manual_complete() . deoplete#close_popup()
endfunc

" Make completion lazy
call deoplete#custom#option('auto_complete', v:false)
inoremap <C-n> <C-r>=deoplete#manual_complete()<Cr>


" MAPPINGS
let mapleader = "\<C-j>" " see :h expr-quote for more on the backslash
" Note: to make multiple mapleaders, simply redefine the mapleader variable right before defining the mappings
nnoremap <Leader>l :set list!<Cr>	  " toggle list option
nnoremap <Leader>f :call ToggleFDC()<Cr>  " toggle foldcolumn
nnoremap <Leader>n :noh<Cr>		  " disable search highlight
nnoremap <Leader>c :set cursorline!<Cr>	  " toggle cursorline
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


" FZF AND SEARCH CONFIG

let g:fzf_layout = { 'down':'~40%' }
function! FzyCommand(search, vim_command)
  " search for a:search in files and filenames ...
  let results = split(system('printf "$(fd -Ht f -c never ' . shellescape(a:search) . ' )\n$(ag -il --nocolor ' . shellescape(a:search) . ' )\n" | sort -u'))

  " ... then pipe it into fzf and enable a preview and multi selection
  let output = fzf#run(fzf#vim#with_preview(fzf#wrap('', {'source':results, 'options':'--multi', 'sink':a:vim_command})))
endfunction

" SEARCH BOTH FILES AND FILE CONTENTS
command! -nargs=1 FF call FzyCommand(<q-args>, "e", 1) | normal /\c<args>/<CR>ggn


" MULTI CURSORS
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-m>'
let g:multi_cursor_select_all_word_key = '<A-m>'
let g:multi_cursor_start_key           = 'g<C-m>'
let g:multi_cursor_select_all_key      = 'g<A-m>'
let g:multi_cursor_next_key            = '<C-m>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'


" FILETYPE SPECIFIC CONFIGS

augroup filetype_lisp

  autocmd BufRead,BufNewFile *.lisp set filetype=lisp

  " In case the auto-formatting isn't enough =)
  " Remember: you can use <C-I> to insert a tab

augroup END

" vim:sts=2:sw=2:noet
