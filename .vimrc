" Vundle ===================================================================
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.

Plugin 'rust-lang/rust.vim'
" Plugin 'terryma/vim-multiple-cursors'
Plugin 'flazz/vim-colorschemes'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'hegemonsherald/vim-codegen'
Plugin 'hegemonsherald/vim-dlx_syntax'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" see :h vundle for more details or wiki for FAQ

" Put your non-Plugin stuff after this line ================================


" SYNTAX AND THEMING
syntax on
color Monokai

" use the terminal's background
highlight Normal ctermbg=none
highlight NonText ctermbg=none

" use underlining when highlighting Search results
highlight Search term=reverse cterm=underline gui=underline guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE


" SET BASIC OPTIONS
set number                      " nu
set relativenumber              " rnu
set hlsearch                    " hls; use :noh to hide highlights
set incsearch                   " highlight searches incrementally
set ignorecase                  " ignore case in search
set smartcase                   " only match case sensitively, if search pattern contains upper case letter; needs ignorecase to function
set autowrite                   " aw
set matchpairs+=<:>             " add brackets to matching symbols
set showcmd                     " shows commands on status-line, is on by default
set ruler                       " ru, is on by default
set listchars=tab:»∙,trail:░,   " lcs, characters for whitespace listing
set list                        " enable whitespace listing
set autoread                    " ar, makes vim reread a file, if it changed
set backspace+=start,eol,indent " allow backspacing over the position, where insert mode was started; end-of-lines; autoindent's indentation
set autoindent
set nowrap
set foldmethod=manual


" MAPPINGS
"nnoremap <Leader>j I// <Esc>   " insert // for commenting the line
"nnoremap <Leader>k I# <Esc>    " insert # for commenting the line
"nnoremap <Leader>l ^dw         " remove comment characters
nnoremap <Leader>l :call ToggleList()<Cr> " toggle list option
nnoremap <Leader>f :call ToggleFDC()<Cr>  " toggle foldcolumn
nnoremap <Leader>n :noh<Cr>               " disable search highlight


" BASIC FUNCTIONS

" Toggles the list setting
func! ToggleList()

  if &list == 0
    set list
  else
    set nolist
  endif

endfunc

func! ToggleFDC()

  if &foldcolumn == 0
    set foldcolumn=5
  else
    set foldcolumn=0
  endif

endfunc


" TEMPLATES
function! CreateCFile()
  set paste " enable paste mode so no auto-formatting is done on the line below
  call append(0, ["#include <stdio.h>", "#include <locale.h>", "", "int main() {", "", "  // Make unicode work", "  setlocale(0, \"\");", "", " ", "", "  return 0;", "", "}"])
  call cursor(9, 1)
  set nopaste
endfunction

function! CreateJavaFile()
  set paste
  norm gg0ipackage ;import acm.program.*;import acm.graphics.*;/** * NAME. */public class ... extends ... { @Override public void run() {     }}ggf;h
  set nopaste
endfunction


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
