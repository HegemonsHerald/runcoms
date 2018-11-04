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

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" see :h vundle for more details or wiki for FAQ

" Put your non-Plugin stuff after this line ================================

" syntax and theming
syntax on
color Monokai

" use the terminal's background
highlight Normal ctermbg=none
highlight NonText ctermbg=none

" use underlining when highlighting Search results
highlight Search term=reverse cterm=underline gui=underline guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE

" set basic options
set number		                  " nu
set relativenumber	            " rnu
set hlsearch		                " hls; use :noh to hide highlights
set incsearch                   " highlight searches incrementally
set ignorecase                  " ignore case in search
set smartcase                   " only match case sensitively, if search pattern contains upper case letter; needs ignorecase to function
set autoindent
set nowrap
set autowrite                   " aw
set matchpairs+=<:>             " add brackets to matching symbols
set showcmd                     " shows commands on status-line, is on by default
set ruler                       " ru, is on by default
set listchars=tab:»∙,trail:░,   " lcs, characters for whitespace listing
set list                        " enable whitespace listing

" mappings
nnoremap <Leader>re :e <C-r>%<CR>	" reloads the current file; <C-r> to paste from a register; the % register contains the current filename
nnoremap <Leader>j I// <Esc>		" insert // for commenting the line
nnoremap <Leader>k I# <Esc>		" insert # for commenting the line
nnoremap <Leader>l ^dw			" remove comment characters

" automatically save and restore views (those contain data on custom folds)
" note: the silent! keyword suppresses error messages from these commands
augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave * silent! mkview  " mkview saves the folds in a viewfile in ~/.vim/views/
  autocmd BufWinEnter * silent! loadview  " loadview loads the appropriate viewfile
augroup END

" change cursor shape for Insert Mode ======================================
" for Gnome Terminal
"if has("autocmd")
"  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
"  au InsertEnter,InsertChange *
"    \ if v:insertmode == 'i' | 
"    \   silent execute '!echo -ne "\e[5 q"' | redraw! |
"    \ elseif v:insertmode == 'r' |
"    \   silent execute '!echo -ne "\e[3 q"' | redraw! |
"    \ endif
"  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
"endif
"
"set guicursor=


let g:fzf_layout = { 'down':'~40%' }
function! FzyCommand(search, vim_command)
  " search for a:search in files and filenames ...
  let results = split(system('printf "$(fd -Ht f -c never ' . shellescape(a:search) . ' )\n$(ag -il --nocolor ' . shellescape(a:search) . ' )\n" | sort -u'))

  " ... then pipe it into fzf and enable a preview and multi selection
  let output = fzf#run(fzf#vim#with_preview(fzf#wrap('', {'source':results, 'options':'--multi', 'sink':a:vim_command})))
endfunction

" search both files and file contents
command! -nargs=1 FF call FzyCommand(<q-args>, "e", 1) | normal /\c<args>/<CR>ggn

function! ToggleList()
  if &list == 0
    set list
  else
    set nolist
  endif
endfunction

" For creating bindings with custom Mapleaders beyond the regular mapleader:
" define a custom mapleader
"let mapleader2="whatever"

" :execute executes its argument-string as an ex command, since its arg is a string you can use variable interpolation to change up your mapleaders in it!
" define your mappings like this:
"execute "nnoremap ".mapleader2."O Owheeee I can do mapleader!<ESC>"

" Note: the mapleader2 stuff above has the actual code commented out, because:
" If a key might be the beginning of a sequence (like w for whatever) vim will
" wait for a specified timeout, before assuming that nothing else comes. I was
" getting that timeout, whenever I used the 'w' motion, which was very annoying.
" See :help ttimeout for more...
