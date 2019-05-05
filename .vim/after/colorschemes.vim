" pre-supposes, that functionals is sourced

let g:colors_name = 'yin'

let g:colorscheme_list = [
			\ 'badwolf',
			\ 'orbital',
			\ 'bubblegum-256-dark',
			\ 'maui',
			\ 'Benokai',
			\ 'Monokai',
			\ 'Tomorrow-Night-Eighties',
			\ 'wolfpack',
			\ 'yin',
			\ 'yang',
			\ 'fahrenheit',
			\ 'iceberg',
			\ '256-grayvim',
			\ 'lapis256',
			\ '256-jungle',
			\ 'OceanicNext',
			\ 'blues',
			\ 'ayu',
			\ 'cobalt2',
			\ 'lucid',
			\ 'anderson',
			\ 'palenight',
			\ 'neodark',
			\ 'spacegray'
			\ ]

" depending on whether you select 256-grayvim coming from iceberg or from
" lapis256, it will change subtly... IDK

" special scheme specific settings, first in the list is on-activation, second is on-deactivation
let g:colorscheme_config = {
			\ '256-grayvim'  : [ 'set notermguicolors', 'set termguicolors' ],
			\ 'lapis256'     : [ 'set notermguicolors', 'set termguicolors' ],
			\ '256-jungle'   : [ 'set notermguicolors', 'set termguicolors' ],
			\ 'Monokai'      : [ [ 'highlight Normal  ctermbg=none guibg=NONE',
			\                      'highlight NonText ctermbg=none guibg=NONE' ],
			\                    '' ]
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


func! EchoSchemeList()

	let list = g:colorscheme_list

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

	if has_key(g:colorscheme_config, g:colors_name)

		" get settings item
		let old_config = g:colorscheme_config[g:colors_name]

		" get leave settings
		let old_config = old_config[1]

	endif


	" get the start settings for the new theme


	if has_key(g:colorscheme_config, a:name)

		" get settings item from
		let new_config = g:colorscheme_config[a:name]

		" get enter settings from settings item
		let new_config = new_config[0]

	endif


	" set the new colorscheme

	call ExecConfig(old_config)

	exec ':colorscheme ' . a:name

	call ExecConfig(new_config)

	let g:colors_name = a:name

	redraw

	echo g:colors_name

endfunc

" executes configuration command[s]
func! ExecConfig(config)

	" multiple commands?
	if type(a:config) == v:t_list
		for cmd in a:config
			exec cmd
		endfor
	
	" single command?
	elseif type(a:config) == v:t_string
		exec a:config
	endif


endfunc

" Sets the colorscheme to the scheme, that has the number of a:index in the list from EchoSchemeList()
func! SetSchemeByIndex(index)

	let list = g:colorscheme_list

	let name = list[a:index]

	call SetScheme(name)

endfunc

" sets the scheme to the scheme, with the next higher index from the EchoSchemeList list
func! NextScheme()

	let list = g:colorscheme_list

	let next_index = IndexOf(g:colors_name, list) + 1

	" set the scheme to the next index, but wrap around if the index gets out of bounds
	call SetSchemeByIndex(next_index >= len(list) ? 0 : next_index)

endfunc

" sets the scheme to the scheme, with the next lower index from the EchoSchemeList list
func! PrevScheme()

	let list = g:colorscheme_list

	let next_index = IndexOf(g:colors_name, list) - 1

	" set the scheme to the next index, but wrap around if the index gets out of bounds
	call SetSchemeByIndex(next_index < 0 ? (len(list) - 1) : next_index)

endfunc

" set a random scheme
func! RandomScheme()

	let list = g:colorscheme_list

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

" These may have to be reconsidered a bit, cause right now I'm just filling up
" the function keys.

nnoremap <F7> :call RandomScheme()<CR>
nnoremap <F8> :call PrevScheme()<CR>
nnoremap <F9> :call NextScheme()<CR>
nnoremap <F10> :call EchoSchemeList()<CR>

" Setting Command
command! -nargs=1 Colo :call ColoCommand(<args>)

" Make setting normal background for transparencies neat
func s:SetNormalBackground()
	highlight Normal  ctermbg=none guibg=NONE
	highlight NonText ctermbg=none guibg=NONE
endfunc
nnoremap <F6> :call <SID>SetNormalBackground()<CR>
