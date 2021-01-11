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
func Highlight(groupName, fg, bg, opts)
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
call Highlight('Normal',          'fg',         'bg',         'none')
call Highlight('Cursor',          'fg',         'bg',         'none')
call Highlight('LineNr',          'yellow2',    'bg',         'none')
call Highlight('CursorLineNR',    'yellow',     'bg',         'bold')
call Highlight('CursorLine',      'none',       'red5',       'none')
call Highlight('CursorColumn',    'none',       'red5',       'none')

" - Number column -
call Highlight('FoldColumn',      'yellow',     'bg',         'none')
call Highlight('SignColumn',      'yellow',     'bg',         'none')
call Highlight('Folded',          'red2',       'red5',       'none')

" - Window/Tab delimiters - 
call Highlight('VertSplit',       'bg',         'bg',         'none')
call Highlight('ColorColumn',     'fg',         'red5',       'none')
call Highlight('TabLine',         'yellow2',    'bg',         'none')
call Highlight('TabLineFill',     'yellow2',    'bg',         'none')
call Highlight('TabLineSel',      'yellow',     'bg',         'bold')

set fillchars=vert:\ ,stl:\ ,stlnc:\ 

" - File Navigation / Searcnone -
call Highlight('Directory',       'red',        'bg',         'bold')
call Highlight('Search',          'bg',         'yellow',     'none')
call Highlight('IncSearch',       'bg',         'yellow',     'none')

" - Prompt/Status -
call Highlight('StatusLine',      'yellow',     'bg',         'bold')
call Highlight('StatusLineNC',    'yellow2',    'bg',         'none')
call Highlight('WildMenu',        'bg',         'green',      'bold')
call Highlight('Question',        'fg',         'bg',         'none')
call Highlight('Title',           'fg',         'bg',         'none')
call Highlight('ModeMsg',         'yellow',     'bg',         'none')
call Highlight('MoreMsg',         'yellow',     'bg',         'none')

" - Visual aid -
call Highlight('MatchParen',      'fg',         'bg',         'reverse')
call Highlight('Visual',          'none',       'yellow2',    'none')
call Highlight('VisualNOS',       'fg',         'bg',         'none')
call Highlight('NonText',         'bg',         'bg',         'none')

call Highlight('Todo',            'cyan',       'bg',         'bold')
call Highlight('Underlined',      'green',      'bg',         'none')
call Highlight('Error',           'white',      'red',        'none')
call Highlight('ErrorMsg',        'white',      'red',        'none')
call Highlight('WarningMsg',      'red',        'bg',         'none')
call Highlight('Ignore',          'red2',       'bg',         'none')
call Highlight('SpecialKey',      'red2',       'bg',         'none')

" --------------------------------
" Variable types
" --------------------------------
call Highlight('Constant',        'green',      'bg',         'none')
call Highlight('Number',          'green',      'bg',         'none')
call Highlight('Boolean',         'green',      'bg',         'none')
call Highlight('Float',           'green',      'bg',         'none')
call Highlight('Character',       'magenta',    'bg',         'none')
call Highlight('String',          'magenta',    'bg',         'none')
call Highlight('StringDelimiter', 'magenta',    'bg',         'none')

call Highlight('Identifier',      'cyan',       'bg',         'none')
call Highlight('Function',        'red',        'bg',         'none')

" --------------------------------
" Language constructs
" --------------------------------
call Highlight('Statement',       'yellow',     'bg',         'none')
call Highlight('Conditional',     'yellow',     'bg',         'none')
call Highlight('Repeat',          'yellow',     'bg',         'none')
call Highlight('Label',           'yellow',     'bg',         'none')
call Highlight('Operator',        'yellow',     'bg',         'none')
call Highlight('Keyword',         'yellow',     'bg',         'none')
call Highlight('Exception',       'yellow',     'bg',         'none')
call Highlight('Comment',         'cyan2',      'bg',         'none')

call Highlight('Special',         'yellow',     'bg',         'none')
call Highlight('SpecialChar',     'cyan',       'bg',         'none')
call Highlight('Tag',             'cyan',       'bg',         'none')
call Highlight('Delimiter',       'yellow',     'bg',         'none')
call Highlight('SpecialComment',  'yellow',     'bg',         'none')
call Highlight('Debug',           'cyan',       'bg',         'none')

" - C like -
call Highlight('PreProc',         'blue',       'bg',         'none')
call Highlight('Include',         'blue',       'bg',         'none')
call Highlight('Define',          'blue',       'bg',         'none')
call Highlight('Macro',           'blue',       'bg',         'none')
call Highlight('PreCondit',       'blue',       'bg',         'none')

call Highlight('Type',            'red',        'bg',         'none')
call Highlight('StorageClass',    'red',        'bg',         'none')
call Highlight('Structure',       'red',        'bg',         'none')
call Highlight('Typedef',         'red',        'bg',         'none')

" --------------------------------
" Diff
" --------------------------------
call Highlight('DiffAdd',         'cyan',       'bg',         'none')
call Highlight('DiffChange',      'yellow',     'bg',         'none')
call Highlight('DiffDelete',      'green',      'bg',         'none')
call Highlight('DiffText',        'fg',         'bg',         'none')

" --------------------------------
" Completion menu
" --------------------------------
call Highlight('Pmenu',           'fg',         'red4',       'none')
call Highlight('PmenuSel',        'bg',         'yellow',     'none')
call Highlight('PmenuSbar',       'fg',         'red4',       'none')
call Highlight('PmenuThumb',      'fg',         'red2',       'none')

" --------------------------------
" Spelling
" --------------------------------
call Highlight('SpellBad',        'cyan',       'bg',         'none')
call Highlight('SpellCap',        'magenta',    'bg',         'none')
call Highlight('SpellLocal',      'blue',       'bg',         'none')
call Highlight('SpellRare',       'yellow',     'bg',         'none')

" }}}

" vim:foldmethod=marker
