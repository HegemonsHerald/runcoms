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
set autoindent
set nowrap
set autowrite                   " aw
set matchpairs+=<:>             " add brackets to matching symbols
set showcmd                     " shows commands on status-line, is on by default
set ruler                       " ru, is on by default
set listchars=tab:»∙,trail:░,   " lcs, characters for whitespace listing
set list                        " enable whitespace listing
set autoread                    " ar, makes vim reread a file, if it changed


" MAPPINGS
"nnoremap <Leader>j I// <Esc>		" insert // for commenting the line
"nnoremap <Leader>k I# <Esc>		" insert # for commenting the line
"nnoremap <Leader>l ^dw			" remove comment characters

" Java specific mappings

" \jms	java method static
" \jmsp	java method static private
" \jm	java method
" \jmp	java method private
" \jsf	java static final
" \jsfp	java static final private

" jp	private in insert mode
" jP	public in insert mode

" \js	System.out.println(...); template abbrev in insert and wraps line in normal

" jif	java if block
" Jif	java if one liner
" jel	java else if block
" Jel	java else if one liner
" jls	java else block
" Jls	java else one liner

" jwhile	java while loop
" jfor	java for loop
" jdo	java do while loop

" joj	java object literal
" Joj	java object

" jarr	java array
" Jarr	java array literal


" TEMPLATES
function! CreateCFile()
	set paste " enable paste mode so no auto-formatting is done on the line below
	call append(0, ["#include <stdio.h>", "#include <locale.h>", "", "int main() {", "", "	// Make unicode work", "	setlocale(0, \"\");", "", "	", "", "	return 0;", "", "}"])
	call cursor(9, 1)
	set nopaste
endfunction

function! CreateJavaFile()
	set paste
	norm gg0ipackage ;import acm.program.*;import acm.graphics.*;/** * NAME. */public class ... extends ... {	@Override	public void run() {			}}ggf;h
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




func! JavaConstant(keywords)

	" disable indent
	set paste

	" make sure to not break the typeahead buffer
	call inputsave()

	" get input
	let type = input("Constant Type: ")
	let name = input("Constant Name: ")
	let val  = input("Constant Value: ")

	" set defaults
	if type == ""
		let type = "int"
	endif
	if name == ""
		let name = "name"
	endif
	if val == ""
		let val = "42"
	endif

	" get line of cursor
	let line = line(".")

	" concatenate the parts
	let constant = a:keywords." static final " .type." ".toupper(name)." = ".val.";"

	" add constant at appropriate indent level
	call setline(line, "\t".constant)

	" re-enable indent
	set nopaste

	" restore the typeahead buffer
	call inputrestore()

endfunc

func! JavaStaticFinalPrivate()
	call JavaConstant("private")
endfunc!

func! JavaStaticFinalPublic()
	call JavaConstant("public")
endfunc!

func! JavaMethod(keywords)

	" disable indent
	set paste

	" make sure to not break the typeahead buffer
	call inputsave()

	" get input
	let type = input("Method Type: ")
	let name = input("Method Name: ")
	let Args = input("Method Args: ")

	" set defaults
	if type == ""
		let type = "void"
	endif
	if name == ""
		let name = "name"
	endif

	" get line of cursor
	let line = line(".")

	" concatenate signature
	let signature = a:keywords." ".type." ".name."(".Args.")"

	" add signature at appropriate indent level
	call setline(line, "\t".signature)

	" add code block and move cursor to middle line
	exec "norm! A {\n\n\t\t\n\n\t}"
	norm! 2k$

	" re-enable indent
	set nopaste

	" restore the typeahead buffer
	call inputrestore()

	" leave in insertmode
	" call feedkeys('A')
	" I'm using inputsave and inputrestore now, which means the As at the end
	" of the mappings below are run after the function call returned, If I
	" didn't use save the As would be fed into the function call and I could
	" use feedkeys to add letters to the typeahead buffer before the call ends
	" to achieve the same behaviour

endfunc

func! JavaMethodStaticPublic()
	call JavaMethod("public static")
endfunc

func! JavaMethodStaticPrivate()
	call JavaMethod("private static")
endfunc

func! JavaMethodPublic()
	call JavaMethod("public")
endfunc

func! JavaMethodPrivate()
	call JavaMethod("private")
endfunc

func! JavaFor()

	" disable indent
	set paste

	" make sure to not break the typeahead buffer
	call inputsave()

	" get input
	let counter = input("Counter Var: ")
	let ref_var = input("Reference Var: ")

	" set defaults
	if counter == ""
		let counter = "i"
	endif
	if ref_var == ""
		let ref_var = "VAR"
	endif

	" get line of cursor
	let line = line(".")

	" concatenate the parts
	let for = "for (int ".counter." = 0; ".counter." < ".ref_var."; ".counter."++)"

	" add for loop
	call setline(line, for)

	" add for loop's code block
	exec "norm! A {\n\n\n}"

	" fix indent and position cursor
	exec "norm! V3k=j"

	" re-enable indent
	set nopaste

	" restore the typeahead buffer
	call inputrestore()

endfunc

func! JavaWhile()

	" disable indent
	set paste

	" make sure to not break the typeahead buffer
	call inputsave()

	" get input
	let counter = input("Counter Var: ")
	let ref_var = input("Reference Var: ")

	" set defaults
	if counter == ""
		let counter = "i"
	endif
	if ref_var == ""
		let ref_var = "VAR"
	endif

	" concatenate the parts
	let while = "while (".counter." < ".ref_var.")"
	let increment = counter."++;"

	" add while loop initial part
	call setline(line("."), while)

	" add while loop's code block
	exec "norm! A {\n\n\n"

	" add counter increment
	call setline(line("."), increment)

	" add the rest of the code block
	exec "norm! A\n\n}"

	" fix indent and position cursor
	exec "norm! V5k=j"

	" re-enable indent
	set nopaste

	" restore the typeahead buffer
	call inputrestore()

endfunc

func! JavaDo()

	" disable indent
	set paste

	" make sure to not break the typeahead buffer
	call inputsave()

	" get input
	let counter = input("Counter Var: ")
	let ref_var = input("Reference Var: ")

	" set defaults
	if counter == ""
		let counter = "i"
	endif
	if ref_var == ""
		let ref_var = "VAR"
	endif

	" concatenate the parts
	let while = "while (".counter." < ".ref_var.");"
	let increment = counter."++;"

	" add while loop initial part
	call setline(line("."), while)

	" add } before the while
	exec "norm! I} "

	" add the code block before the while line
	exec "norm! Odo {\n\n\n"

	" add counter increment
	call setline(line("."), increment)

	" add the rest of the code block
	exec "norm! A\n"

	" fix indent and position cursor
	exec "norm! jV5k=j"

	" re-enable indent
	set nopaste

	" restore the typeahead buffer
	call inputrestore()

endfunc

func! JavaIf()

	" disable indent
	set paste

	" make sure to not break the typeahead buffer
	call inputsave()

	" get input
	let expr = input("Condition: ")

	" concatenate the parts
	let if = "if (".expr.")"

	" add if statement initial part
	call setline(line("."), if)

	" add if block's block
	exec "norm! A {\n\n\n}"

	" fix indent and position cursor
	exec "norm! V3k=j"

	" re-enable indent
	set nopaste

	" restore the typeahead buffer
	call inputrestore()

endfunc

func! JavaElif()

	" disable indent
	set paste

	" make sure to not break the typeahead buffer
	call inputsave()

	" get input
	let expr = input("Condition: ")

	" concatenate the parts
	let elif = "else if (".expr.")"

	" add line after '}' of the if block
	exec "norm! o\e"

	" add else if part
	call setline(line("."), elif)

	" put the else if on the correct line
	exec "norm! kJ"

	" add else if code block
	exec "norm! A {\n\n\n}"

	" fix indent and position cursor
	exec "norm! V3k=j"

	" re-enable indent
	set nopaste

	" restore the typeahead buffer
	call inputrestore()

endfunc

func! JavaObj(keywords)

	" disable indent
	set paste

	" make sure to not break the typeahead buffer
	call inputsave()

	" get input
	let type = input("Type: ")
	let name = input("Name: ")
	let Args = input("Args: ")

	if type == ""
		let type = "int"
	endif
	if name == ""
		let name = "name"
	endif

	" concatenate the parts
	let obj = a:keywords."".type." ".name." = new ".type."(".Args.");"

	" newline, that will be merged later for non-destructive editing
	exec "norm! o"

	" add object
	call setline(line("."), obj)

	" merge newline
	exec "norm! kJ0"

	" formatting and cursor position
	exec "norm! V="

	" re-enable indent
	set nopaste

	" restore the typeahead buffer
	call inputrestore()

endfunc

func! JavaObjLiteral(keywords)

	" disable indent
	set paste

	" make sure to not break the typeahead buffer
	call inputsave()

	" get input
	let type = input("Type: ")
	let name = input("Name: ")
	let val  = input("Value: ")

	if type == ""
		let type = "int"
	endif
	if name == ""
		let name = "name"
	endif
	if val == ""
		let val = "42"
	endif

	" concatenate the parts
	let obj = a:keywords."".type." ".name." = ".val.";"

	" newline, that will be merged later for non-destructive editing
	exec "norm! o"

	" add object
	call setline(line("."), obj)

	" merge newline
	exec "norm! kJ0"

	" formatting and cursor position
	exec "norm! V="

	" re-enable indent
	set nopaste

	" restore the typeahead buffer
	call inputrestore()

endfunc

func! JavaArr(keywords)

	" disable indent
	set paste

	" make sure to not break the typeahead buffer
	call inputsave()

	" get input
	let type = input("Type: ")
	let name = input("Name: ")

	if type == ""
		let type = "int"
	endif
	if name == ""
		let name = "name"
	endif

	" concatenate the parts
	let arr = a:keywords."".type." ".name."[] = new ".type."[];"

	" newline, that will be merged later for non-destructive editing
	exec "norm! o"

	" formatting and cursor position
	exec "norm! V="
	exec "norm! $h"

	" add array
	call setline(line("."), arr)

	" merge newline
	exec "norm! kJ0"

	" re-enable indent
	set nopaste

	" restore the typeahead buffer
	call inputrestore()

endfunc

func! JavaArrLiteral(keywords)

	" disable indent
	set paste

	" make sure to not break the typeahead buffer
	call inputsave()

	" get input
	let type = input("Type: ")
	let name = input("Name: ")

	if type == ""
		let type = "int"
	endif
	if name == ""
		let name = "name"
	endif

	" concatenate the parts
	let arr = a:keywords."".type." ".name."[] = {};"

	" newline, that will be merged later for non-destructive editing
	exec "norm! o"

	" add array
	call setline(line("."), arr)

	" merge newline
	exec "norm! kJ0"

	" formatting and cursor position
	exec "norm! V="
	exec "norm! $h"

	" re-enable indent
	set nopaste

	" restore the typeahead buffer
	call inputrestore()

endfunc

func! JavaDocParams()

	" get the function's signature
	let signature = getline(line("."))

	" separate signature into required bits
	let name = substitute(signature, '^.*\(\<.*\>\)(.*', '\1', '')
	let args = substitute(signature, '^.*(\(.*\)).*', '\1', '')
	let return = substitute(signature, '^.*\(\<.*\>\) \<.*\>(.*).*', '\1', '')

	" split args into a list, if there's nothing it'll be empty
	let args = split(args, ',')

	" create a list, that's gonna contain the lines of the javadoc
	let doc_lines = []

	" add the first line to the javadoc lines
	call add(doc_lines, "/** ".name.".")

	" for all the arguments, that are there (none if there aren't any)...
	for argument in args
		" ... delete the first word, that's the type, of the argument...
		let arg = substitute(argument, '^.*\> \(.*\)', '\1', '')
		" ... add the argument with the @param text to the javadoc lines
		call add(doc_lines, "* @param ".arg."	Here something useful about {@code ".arg."}.")
	endfor

	" if the return type isn't void...
	if return != "void"
		" ... add a return tag
		call add(doc_lines, "* @return	The thing returns a thing, I guess.")
	endif

	" add the finish line of the javadoc
	call add(doc_lines, "*/")

	" add the javadoc to the file

	" move up a line, to append before the signature
	norm! k

	" if there's only the first line and the javadoc end...
	if len(doc_lines) == 2
		" ... add the javadoc as a one-liner
		call append(line("."), [join(doc_lines)])
	else
		" ... else add the javadoc's lines en proper
		call append(line("."), doc_lines)
	endif

	" append doesn't move the cursor, so move down to the first line of the javadoc
	norm! j

	" select the javadoc and format it for indentation
	exec "norm! V".len(doc_lines)."j="

endfunc

func! JavaDocParamsAll()

	" save cursor position
	norm m[

	" move to top
	norm gg

	" while there's another function signature to work with... (note: 'W' so this won't loop infinitely)
	while search('.*\<.*\> \<.*\>(.*) {.*', 'W') != 0

		" get the line above the signature
		let line_above = getline(line(".")-1)

		" if the line above that signature isn't a javadoc or override...
		if line_above !~ '\*\/' && line_above !~ '@Override'
			" ... add a javadoc to it
			call JavaDocParams()
		endif

	endwhile

	" move cursor back to where it was
	norm `[

endfunc

" calls to functions
autocmd FileType java inoremap jfor <Esc>   :call JavaFor()<Cr>o
autocmd FileType java inoremap jwhile <Esc> :call JavaWhile()<Cr>o
autocmd FileType java inoremap jdo <Esc>    :call JavaDo()<Cr>o
autocmd FileType java inoremap jif <Esc> :call JavaIf()<Cr>o
autocmd FileType java inoremap jel <Esc> :call JavaElif()<Cr>o
autocmd FileType java inoremap joj <Esc> :call JavaObjLiteral("")<Cr>A
autocmd FileType java inoremap Joj <Esc> :call JavaObj("")<Cr>A
autocmd FileType java inoremap jarr <Esc> :call JavaArr("")<Cr>i
autocmd FileType java inoremap Jarr <Esc> :call JavaArrLiteral("")<Cr>i
autocmd FileType java nnoremap <leader>jms  :call JavaMethodStaticPrivate()<Cr>A
autocmd FileType java nnoremap <leader>jmsp :call JavaMethodStaticPublic()<Cr>A
autocmd FileType java nnoremap <leader>jm   :call JavaMethodPrivate()<Cr>A
autocmd FileType java nnoremap <leader>jmp  :call JavaMethodPublic()<Cr>A
autocmd FileType java nnoremap <leader>jsf  :call JavaStaticFinalPrivate()<Cr>
autocmd FileType java nnoremap <leader>jsfp :call JavaStaticFinalPublic()<Cr>
autocmd FileType java nnoremap <leader>jdoc :call JavaDocParams()<Cr>
autocmd FileType java nnoremap <leader>Jdoc :call JavaDocParamsAll()<Cr>

" these ones are plain macros, that add something and format it and possibly
autocmd FileType java inoremap jls <Esc>:exec "norm! oelse {\n\n\n}\eV3k=kJ"<Cr>jo
autocmd FileType java inoremap Jif <Esc>:exec "norm! Aif () ;"<Cr>V=$2hi
autocmd FileType java inoremap Jel <Esc>:exec "norm! Aelse if () ;"<Cr>V=$2hi
autocmd FileType java inoremap Jls <Esc>:exec "norm! Aelse ;"<Cr>V=$i

" these have <Esc>a at the end to insure the space
autocmd FileType java inoremap jp private <Esc>a
autocmd FileType java inoremap jP public <Esc>a

" println, the second one surrounds whats already there
autocmd FileType java inoremap <leader>js System.out.println();<Left><Left>
autocmd FileType java nnoremap <leader>js ISystem.out.println(<Esc>A);<Esc>V=0F(
