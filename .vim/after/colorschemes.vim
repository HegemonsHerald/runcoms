let g:colors_name = 'yin'

" selection of schemes compatible with either gui or tui
let g:colorscheme_list_either = [
			\ 'badwolf',
			\ 'orbital',
			\ 'bubblegum-256-dark',
			\ 'maui',
			\ 'Benokai',
			\ 'Monokai',
			\ 'Tomorrow-Night-Eighties',
			\ 'wolfpack',
			\ 'yin',
			\ 'yang'
			\ ]

" selection of schemes only compatible with tui, or especially compatible with tui
" (this includes themes, that look good but wildly different from their tui version)
let g:colorscheme_list_tui = [
			\ 'fahrenheit',
			\ 'iceberg',
			\ '256-jungle',
			\ '256-grayvim',
			\ 'lapis256',
			\ 'OceanicNext',
			\ 'blues',
			\ 'palenight'
			\ ]

" selection of schemes only compatible with gui, or especially compatible with gui
" (this includes themes, that look good but wildly different from their gui version)
let g:colorscheme_list_gui = [
			\ 'ayu',
			\ 'cobalt2',
			\ 'lucid',
			\ 'anderson',
			\ 'OceanicNext',
			\ 'palenight'
			\ ]

" special scheme specific settings, first in the list is on-activation, second is on-deactivation
let g:colorscheme_config_gui = {
			\ 'cobalt2'  : [ 'set cursorline! cursorline?', 'set cursorline! cursorline?' ]
			\ }

let g:colorscheme_config_tui = {
			\ 'lapis256' : [ 'set cursorline! cursorline?', 'set cursorline! cursorline?' ]
			\ }

" UTILITIES

" returns the index of element in list, or -1 if element doesn't exist
func! FindInList(list, element)

	for i in range(len(a:list))

		if a:list[i] == a:element
			return i
		endif
	endfor

	return -1

endfunc

" uses bash's $RANDOM env variable to generate a random integer between lower and upper
func! GetRandomNumber(lower, upper)

	" get a random number from bash
	let rand = str2nr(system('/bin/bash -c "echo -n $RANDOM"'))

	let bash_rand_delta = 32767.0				" note, that this is a float
	let range_delta = a:upper - a:lower
	let map_factor = range_delta / bash_rand_delta

	" map $RANDOM to the specified range
	let rand = a:lower + map_factor * rand

	" convert the mapped rand back to an integer
	return float2nr(rand)

endfunc


" SCHEME LIST

func! MakeGUISchemeList()
	return g:colorscheme_list_either + g:colorscheme_list_gui
endfunc

func! MakeTUISchemeList()
	return g:colorscheme_list_either + g:colorscheme_list_tui
endfunc

func! MakeCurrentSchemeList()
	return has('gui_running') ? MakeGUISchemeList() : MakeTUISchemeList()
endfunc

func! EchoSchemeList()

	let list = MakeCurrentSchemeList()

	for i in range(len(list))

		let el = list[i]

		" Highlight the current theme
		if el == g:colors_name
			echohl Keyword
		else
			echohl None
		endif

		" print the current theme
		echo i . ': ' . el

	endfor

endfunc


" SCHEME CHANGE

" Sets the colorscheme to a:name, and runs the appropriate config commands
func! SetScheme(name)

	let new_config = ''
	let old_config = ''


	" get the leave settings for the old theme

	if has('gui_running') && has_key(g:colorscheme_config_gui, g:colors_name)

		" get settings item from gui settings
		let old_config = g:colorscheme_config_gui[g:colors_name]

		" get leave settings from settings item
		let old_config = old_config[1]

	elseif has_key(g:colorscheme_config_tui, g:colors_name)

		" get settings item from tui settings
		let old_config = g:colorscheme_config_tui[g:colors_name]

		" get leave settings from settings item
		let old_config = old_config[1]

	endif


	" get the start settings for the new theme

	if has('gui_running') && has_key(g:colorscheme_config_gui, a:name)

		" get settings item from gui settings
		let new_config = g:colorscheme_config_gui[a:name]

		" get enter settings from settings item
		let new_config = new_config[0]

	elseif has_key(g:colorscheme_config_tui, a:name)

		" get settings item from tui settings
		let new_config = g:colorscheme_config_tui[a:name]

		" get enter settings from settings item
		let new_config = new_config[0]

	endif


	" set the new colorscheme

	exec old_config

	exec ':colorscheme ' . a:name

	exec new_config

	let g:colors_name = a:name

endfunc

" Sets the colorscheme to the scheme, that has the number of a:index in the list from EchoSchemeList()
func! SetSchemeByIndex(index)

	let list = MakeCurrentSchemeList()

	let name = list[a:index]

	call SetScheme(name)

endfunc

" sets the scheme to the scheme, with the next higher index from the EchoSchemeList list
func! NextScheme()

	let list = MakeCurrentSchemeList()

	let next_index = FindInList(list, g:colors_name) + 1

	" set the scheme to the next index, but wrap around if the index gets out of bounds
	call SetSchemeByIndex(next_index >= len(list) ? 0 : next_index)

endfunc

" sets the scheme to the scheme, with the next lower index from the EchoSchemeList list
func! PrevScheme()

	let list = MakeCurrentSchemeList()

	let next_index = FindInList(list, g:colors_name) - 1

	" set the scheme to the next index, but wrap around if the index gets out of bounds
	call SetSchemeByIndex(next_index < 0 ? (len(list) - 1) : next_index)

endfunc

" set a random scheme
func! RandomScheme()

	let list = MakeCurrentSchemeList()

	let index = GetRandomNumber(0, len(list) - 1)

	call SetScheme(list[index])

endfunc

" set scheme either by name or by index
func! ColoCommand(word)

	let t = type(a:word)

	if t == v:t_string
		call SetScheme(a:word)
	elseif t == v:t_number
		call SetSchemeByIndex(a:word)
	endif

endfunc


" MAPPINGS

nnoremap <F7> :call RandomScheme()<CR>
nnoremap <F8> :call PrevScheme()<CR>
nnoremap <F9> :call NextScheme()<CR>
nnoremap <F10> :call EchoSchemeList()<CR>

" Setting Command
command! -nargs=1 Colo :call ColoCommand(<args>)
