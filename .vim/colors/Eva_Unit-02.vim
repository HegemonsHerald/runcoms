" Quick Explanation: {{{
" ------------------
" 
" The highlight command defines the various syntax styles. It takes the name of
" a highlight group followed by the style options for that group as arguments:
" 
"   :highlight {group-name} {key}={value} ...
" 
" The relevant style options are accessed through keywords:
" 
"   cterm={attr-list}       " set style for xterm
" 
"   ctermfg={color-nr}      " set fg color for xterm
"   ctermbg={color-nr}      " set bg color for xterm
" 
"   guifg={color-name}      " set fg color for gui / truecolor
"   guibg={color-name}      " set bg color for gui / truecolor
" 
" The attr-list contains these options:
" 
"   none
"   bold
"   underline
"   reverse
"   italic
"   standout
"   nocombine
" 
" A color-nr is the index of a color in the ranges 0-15 or 0-255.
" 
" A color-name can be any of the gui-colors (see :h gui-colors) or a hex coded
" rgb color.
" 
" IF THE termguicolors OPTION IS SET, VIM WILL USE GUIFG AND GUIBG IN TRUECOLOR
" CAPABLE TERMINALS IN PLACE OF CTERMFG AND CTERMBG.
"
" }}}

" Initialization: {{{

highlight clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name="Eva_Unit-02"

" }}}

" Palette: {{{

" Color palette where each color has a cterm code and a hex code assigned.
" This way the palette will work in guis, truecolor capable terminals, and
" regular xterms.

let s:palette = {}

let s:palette.none          = { 'cterm':'none', 'gui':'NONE'    }  " transparent to the terminal
let s:palette.fg            = { 'cterm':'07',   'gui':'#eeeeee' }
let s:palette.bg            = { 'cterm':'none', 'gui':'#350000' }
let s:palette.black         = { 'cterm':'00',   'gui':'#000000' }
let s:palette.red           = { 'cterm':'01',   'gui':'#ff2215' }
let s:palette.green         = { 'cterm':'02',   'gui':'#f65b3d' }
let s:palette.yellow        = { 'cterm':'03',   'gui':'#feb100' }
let s:palette.blue          = { 'cterm':'04',   'gui':'#86a4fa' }
let s:palette.magenta       = { 'cterm':'05',   'gui':'#ce22b2' }
let s:palette.cyan          = { 'cterm':'06',   'gui':'#40debd' }
let s:palette.white         = { 'cterm':'07',   'gui':'#eeeeee' }
let s:palette.black2        = { 'cterm':'08',   'gui':'#575757' }
let s:palette.red2          = { 'cterm':'09',   'gui':'#b91003' }
let s:palette.green2        = { 'cterm':'10',   'gui':'#ca2f0b' }
let s:palette.yellow2       = { 'cterm':'11',   'gui':'#d67b00' }
let s:palette.blue2         = { 'cterm':'12',   'gui':'#5453a0' }
let s:palette.magenta2      = { 'cterm':'13',   'gui':'#92137f' }
let s:palette.cyan2         = { 'cterm':'14',   'gui':'#269e9d' }
let s:palette.white2        = { 'cterm':'15',   'gui':'#ffffff' }
let s:palette.red3          = { 'cterm':'08',   'gui':'#730401' }  " extra from Eva Unit-02 palette, not in terminal colors
let s:palette.red4          = { 'cterm':'08',   'gui':'#5e0600' }  " extra from Eva Unit-02 palette, not in terminal colors
let s:palette.red5          = { 'cterm':'08',   'gui':'#3e0200' }  " extra from Eva Unit-02 palette, not in terminal colors

" The Highlight function runs the highlight command on the group called
" groupName, with the colors selected from the palette for both cterm and gui.
func! s:Highlight(groupName, fg, bg, opts)
  let ctermfg = s:palette[a:fg]['cterm']
  let   guifg = s:palette[a:fg]['gui']
  let ctermbg = s:palette[a:bg]['cterm']
  let   guibg = s:palette[a:bg]['gui']
  exe 'hi ' . a:groupName . ' ctermfg=' . ctermfg . ' ctermbg=' . ctermbg . ' guifg=' . guifg . ' guibg=' . guibg . ' cterm=' . a:opts
endfunc

" }}}

" Highlight definitions: {{{

" --------------------------------
" Editor settings
" --------------------------------
call s:Highlight('Normal',          'fg',         'bg',         'none')
call s:Highlight('Cursor',          'fg',         'bg',         'none')
call s:Highlight('LineNr',          'yellow2',    'bg',         'none')
call s:Highlight('CursorLineNR',    'yellow',     'bg',         'bold')
call s:Highlight('CursorLine',      'none',       'red5',       'none')
call s:Highlight('CursorColumn',    'none',       'red5',       'none')

" - Number column -
call s:Highlight('FoldColumn',      'yellow',     'bg',         'none')
call s:Highlight('SignColumn',      'yellow',     'bg',         'none')
call s:Highlight('Folded',          'red2',       'red5',       'none')

" - Window/Tab delimiters - 
call s:Highlight('VertSplit',       'bg',         'bg',         'none')
call s:Highlight('ColorColumn',     'none',       'red5',       'none')
call s:Highlight('TabLine',         'yellow2',    'bg',         'none')
call s:Highlight('TabLineFill',     'yellow2',    'bg',         'none')
call s:Highlight('TabLineSel',      'yellow',     'bg',         'bold')

set fillchars=vert:\ ,stl:\ ,stlnc:\ 

" - File Navigation / Searcnone -
call s:Highlight('Directory',       'red',        'bg',         'bold')
call s:Highlight('Search',          'bg',         'yellow',     'none')
call s:Highlight('IncSearch',       'bg',         'yellow',     'none')

" - Prompt/Status -
call s:Highlight('StatusLine',      'yellow',     'bg',         'bold')
call s:Highlight('StatusLineNC',    'yellow2',    'bg',         'none')
call s:Highlight('WildMenu',        'bg',         'green',      'bold')
call s:Highlight('Question',        'fg',         'bg',         'none')
call s:Highlight('Title',           'fg',         'bg',         'none')
call s:Highlight('ModeMsg',         'yellow',     'bg',         'none')
call s:Highlight('MoreMsg',         'yellow',     'bg',         'none')

" - Visual aid -
call s:Highlight('MatchParen',      'fg',         'bg',         'reverse')
call s:Highlight('Visual',          'none',       'yellow2',    'none')
call s:Highlight('VisualNOS',       'fg',         'bg',         'none')
call s:Highlight('NonText',         'bg',         'bg',         'none')

call s:Highlight('Todo',            'cyan',       'bg',         'bold')
call s:Highlight('Underlined',      'green',      'bg',         'none')
call s:Highlight('Error',           'white',      'red',        'none')
call s:Highlight('ErrorMsg',        'white',      'red',        'none')
call s:Highlight('WarningMsg',      'red',        'bg',         'none')
call s:Highlight('Ignore',          'red2',       'bg',         'none')
call s:Highlight('SpecialKey',      'red2',       'bg',         'none')

" --------------------------------
" Variable types
" --------------------------------
call s:Highlight('Constant',        'green',      'bg',         'none')
call s:Highlight('Number',          'green',      'bg',         'none')
call s:Highlight('Boolean',         'green',      'bg',         'none')
call s:Highlight('Float',           'green',      'bg',         'none')
call s:Highlight('Character',       'magenta',    'bg',         'none')
call s:Highlight('String',          'magenta',    'bg',         'none')
call s:Highlight('StringDelimiter', 'magenta',    'bg',         'none')

call s:Highlight('Identifier',      'cyan',       'bg',         'none')
call s:Highlight('Function',        'red',        'bg',         'none')

" --------------------------------
" Language constructs
" --------------------------------
call s:Highlight('Statement',       'yellow',     'bg',         'none')
call s:Highlight('Conditional',     'yellow',     'bg',         'none')
call s:Highlight('Repeat',          'yellow',     'bg',         'none')
call s:Highlight('Label',           'yellow',     'bg',         'none')
call s:Highlight('Operator',        'yellow',     'bg',         'none')
call s:Highlight('Keyword',         'yellow',     'bg',         'none')
call s:Highlight('Exception',       'yellow',     'bg',         'none')
call s:Highlight('Comment',         'cyan2',      'bg',         'none')

call s:Highlight('Special',         'yellow',     'bg',         'none')
call s:Highlight('SpecialChar',     'cyan',       'bg',         'none')
call s:Highlight('Tag',             'cyan',       'bg',         'none')
call s:Highlight('Delimiter',       'yellow',     'bg',         'none')
call s:Highlight('SpecialComment',  'yellow',     'bg',         'none')
call s:Highlight('Debug',           'cyan',       'bg',         'none')

" - C like -
call s:Highlight('PreProc',         'blue',       'bg',         'none')
call s:Highlight('Include',         'blue',       'bg',         'none')
call s:Highlight('Define',          'blue',       'bg',         'none')
call s:Highlight('Macro',           'blue',       'bg',         'none')
call s:Highlight('PreCondit',       'blue',       'bg',         'none')

call s:Highlight('Type',            'red',        'bg',         'none')
call s:Highlight('StorageClass',    'red',        'bg',         'none')
call s:Highlight('Structure',       'red',        'bg',         'none')
call s:Highlight('Typedef',         'red',        'bg',         'none')

" --------------------------------
" Diff
" --------------------------------
call s:Highlight('DiffAdd',         'cyan',       'bg',         'none')
call s:Highlight('DiffChange',      'yellow',     'bg',         'none')
call s:Highlight('DiffDelete',      'green',      'bg',         'none')
call s:Highlight('DiffText',        'fg',         'bg',         'none')

" --------------------------------
" Completion menu
" --------------------------------
call s:Highlight('Pmenu',           'fg',         'red4',       'none')
call s:Highlight('PmenuSel',        'bg',         'yellow',     'none')
call s:Highlight('PmenuSbar',       'fg',         'red4',       'none')
call s:Highlight('PmenuThumb',      'fg',         'red2',       'none')

" --------------------------------
" Spelling
" --------------------------------
call s:Highlight('SpellBad',        'cyan',       'bg',         'none')
call s:Highlight('SpellCap',        'magenta',    'bg',         'none')
call s:Highlight('SpellLocal',      'blue',       'bg',         'none')
call s:Highlight('SpellRare',       'yellow',     'bg',         'none')

" }}}

" vim:foldmethod=marker
