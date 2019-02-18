" Vundle ===================================================================
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" RUUUUUUST
Plugin 'rust-lang/rust.vim'

" Language Server
Plugin 'autozimu/LanguageClient-neovim'

" More advanced autocompletion
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'Shougo/deoplete.nvim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh'
  \ }

" Tiny things
Plugin 'flazz/vim-colorschemes'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" My things
Plugin 'hegemonsherald/vim-codegen'
Plugin 'hegemonsherald/vim-dlx_syntax'

call vundle#end()
filetype plugin indent on

" Brief help
" see :h vundle for more details or wiki for FAQ

" Put your non-Plugin stuff after this line ================================


" laguage client neovim

set hidden
let g:LanguageClient_serverCommands = {
      \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
      \ }


" SYNTAX AND THEMING
syntax on
color Monokai

" use the terminal's background
highlight Normal ctermbg=none
highlight NonText ctermbg=none

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
set listchars=tab:»∙,trail:░,	" lcs, characters for whitespace listing
set list			" enable whitespace listing
set autoread			" ar, makes vim reread a file, if it changed
set backspace+=start,eol,indent	" allow backspacing over the position, where insert mode was started; end-of-lines; autoindent's indentation
set autoindent
set smarttab			" make use of sts and sw for <tab>-insertion
set nowrap
set foldmethod=manual


" DEOPLETE CONFIG
" Note: the dependancy nvim-yarp of this, requires pynvim to be installed
" (pip3 install pynvim)
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
      \ 'auto_complete': v:false,
      \ })

" Make it select the first item from the menu
set completeopt=menu,noinsert

" Map deoplete to CTRL-N
inoremap <C-n> <C-r>=Deoplete_helper()<Cr>

func! Deoplete_helper()
  return deoplete#manual_complete() . deoplete#close_popup()
endfunc


" MAPPINGS
"nnoremap <Leader>j I// <Esc>   " insert // for commenting the line
"nnoremap <Leader>k I# <Esc>    " insert # for commenting the line
"nnoremap <Leader>l ^dw         " remove comment characters
nnoremap <Leader>l :call ToggleList()<Cr> " toggle list option
nnoremap <Leader>f :call ToggleFDC()<Cr>  " toggle foldcolumn
nnoremap <Leader>n :noh<Cr>		  " disable search highlight


" BASIC FUNCTIONS

" Toggles the list setting
func! ToggleList()

  if &list == 0
    set list
  else
    set nolist
  endif

endfunc

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

" vim:sts=2:sw=2:noet
