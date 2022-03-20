"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                             "
" COMMON.VIM                                                                  "
" Holds all commands and settings to be used across all OS'es at all times.   "
" For NixOS, the plugins are managed by the OS                                "
" For all others OS'es, I am using vim plug for plugin management.            "
"                                                                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Interface {{{

" User Interface {{{

" Detect file types.
filetype indent plugin on

set modelines=0 " Modelines set to 0.
set nomodeline  " Turns off modelines for security.
set title       " Set title of terminal.
set mouse=a     " Allow mouse usage in all modes.
set confirm     " Always confirm irreversible commands.
set lazyredraw  " Does not redraws screen during operations.

if has('nvim')
    " Sha(red) da(ta) settings.
    " Save the marks of the last 100 files.
    " Remember the last 50 lines of registers.
    " Items with more than 10 KiB are ignored.
    " Do not highlight last searches.
    " Save and restore the buffer list.
    " Forget anything in the following directories:
    " * /run/media
    " * /temp
    " * /tmp
    set shada=!,'100,<50,s10,h,r/run/media,r/temp,r/tmp
endif

" Set leader to spacebar.
let mapleader=" "

" Set localleader to backslash.
let maplocalleader="\\"

" }}}

" Appearance {{{

if has('nvim')
    syntax enable          " Enable syntax colouring.
    set termguicolors      " Use the true (24-bit) colours instead of the terminal options.
    colorscheme savanna    " Use my customized theme, located at colors/savanna.vim.

    set inccommand=nosplit " Show the incremental effects of typing in an command.
endif

" Changes cursor shape depending on the current mode.
" Normal mode     = box
" Insert mode     = line
" Overstrike mode = underline
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
 \,a:blinkwait700-blinkoff400-blinkon250
 \,sm:block-blinkwait175-blinkoff150-blinkon175

" }}}

" Text Area {{{
" i.e. the part of the UI that shows the text.

set showmatch          " Prints the matching bracket.
set scrolloff=3        " Cursor will always be 3 lines above or below the screen margins.
set list               " Show tabs and EOL.
set wrap               " Turns on word wrap.
set colorcolumn=80,100 " Colour the 80th and 100th columns.

" }}}

" Gutter {{{
" Columns to the right, displaying line numbers and (with plugins) git status
" and marks.

set number         " Prints the line numbers on the left margin.
set relativenumber " Prints the relative line numbers on the left margin.

" Switch between relative and absolute line numbering.
nnoremap <silent> <leader>n :set relativenumber!<CR>

" }}}

" Status Line {{{

" Setup lightline
" cursorpos: current line number:column line number/total lines.
let g:lightline = {
    \ 'colorscheme': 'deus',
    \ 'active': {
    \   'left': [ [ 'bufnum', 'modified', 'readonly' ],
    \             [ 'relativepath' ] ],
    \   'right': [ [ 'charvaluehex', 'percentwin', 'cursorpos' ],
    \              [ 'fileformat', 'filetype', 'spell' ] ]
    \ },
    \ 'inactive': {
    \   'left': [ [ 'bufnum' ], [ 'filename' ] ],
    \   'right': [ [ 'percentwin', 'cursorpos' ] ]
    \ },
    \ 'component': {
    \   'cursorpos': '%l:%c/%L'
    \ }
\ }

" }}}

" Command Line and Messages {{{

" Show non-normal mode status.
set showmode

" Quit neovim with 'Q' at the command line
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))

" Always show buffer absolute path with Ctrl-G
nnoremap <C-g> 1<C-g>

" Auto search help
nnoremap <leader>h :help<Space>

" Get to the command history easier
nnoremap q; q:

" No colorcolumns in Command Line windows
augroup command_line_appearance
    autocmd!
    autocmd CmdwinEnter * setlocal colorcolumn=
augroup END

" }}}

" Windows {{{

" Use <leader>w as a alternate keybinding for <C-w> keycords
nnoremap <leader>w <C-w>

" Open new windows below and right of the current window.
set splitbelow
set splitright

" Sets Control + h/j/k/l to move across windows.
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" }}}

" Files {{{

" Map double leader (double space) to save but not quit.
nnoremap <leader><leader> :w<CR>

" Expand the path of the current file within command mode.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Vim already has some 'fuzzy' finding ablities on its own, so let's use them
" here. This is for finding files in the current directory.
nnoremap <leader>f :find<Space>

" Set path to search the current directory and any of its subdirectories
" recursively.
set path=.,,**

if has('nvim')
    " Disable netrwPlugin
    let g:loaded_netrwPlugin = 1
    let g:loaded_netrw = 1
lua << EOF
    require("dirbuf").setup {
        sort_order = "directories_first",
    }
EOF
endif

" }}}

" Buffers {{{

" Open list of buffers, then search currently open buffers.
nnoremap <leader>b :buffers<CR>:b<Space>

" Move between the alternate buffer more easily.
nnoremap <leader>t <C-^>

" }}}

" }}}

" Editing {{{

" Cursor Movement and Searching {{{

" Navigate by screen line with j and k, unless it has a count (arrows keys use default behavior).
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" Magic search by default.
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

set ignorecase " Ignores case in searches.
set smartcase  " Enables case-sensitivity with uppercase characters.
set infercase  " Will match cases in auto-completions.

" Clear search highlighting.
nnoremap <silent> <leader>l :nohlsearch<CR>

" Show mark locations
nnoremap <leader>m :marks<CR>

" }}}

" Insertion {{{

" Indentation
" These are often changed for specific filetypes or projects.
set smartindent  " Turns on smart-indenting.
set expandtab    " Replaces default tab with number of spaces.
set shiftwidth=4 " Set the number of spaces for each indent.

" List out all abbreviations
nnoremap <silent> <leader>a :abbreviate<CR>

if has('nvim')
    " Either insert pairs for punctation that can, but normally isn't used for
    " pairs, or insert a opening bracket with the matching pair. Also can insert
    " bracket pairs on seperate lines, and start new typing with in th bracket.
    inoremap <A-(> <C-g>u()<Left>
    inoremap <A-)> <C-g>u(<CR>);<Up><C-o>o
    inoremap <A-[> <C-g>u[]<Left>
    inoremap <A-]> <C-g>u[<CR>];<Up><C-o>o
    inoremap <A-{> <C-g>u{}<Left>
    inoremap <A-}> <C-g>u{<CR>};<Up><C-o>o
    inoremap <A-<> <C-g>u<><Left>
    inoremap <A-'> <C-g>u''<Left>
    inoremap <A-"> <C-g>u""<Left>
    inoremap <A-`> <C-g>u``<Left>
endif

" Use abbreviations to insert completely empty pairs
iabbrev ;9 ()
iabbrev ;( ()
iabbrev ;[ []
iabbrev ;b []
iabbrev ;{ {}
iabbrev ;B {}

" Insert undo breakpoint after certian punctuation marks.
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

" }}}

" Completion {{{

set wildmenu                   " Use the advanced 'wildcard' menu for completion.
set wildmode=longest,list,full " Complete to longest string, list all matches, complete to next fullest match.

" Completion should never insert nor select a suggestion until the user chooses an option.
" Also should always show a menu, even if there is only one choice.
set completeopt=menu,preview,noinsert,menuone,noselect
" When using generic autocompletion, also get suggestions from the spelling dictionary.
set complete+=kspell

if ! has('nvim')
    " Enable omni-completion.
    set omnifunc=syntaxcomplete#Complete
endif

" }}}

" Modification {{{

" Repeat last macro with 'Q' in normal mode
nnoremap Q @@

if has('nvim')
    " Map the alignment plugin
    nmap gl <Plug>(EasyAlign)
    xmap gl <Plug>(EasyAlign)
endif

" }}}

" Undos {{{

if has('nvim')
    set undofile                       " Keep persistent undos.
    let g:undotree_WindowLayout = 2    " Show undo differences in large window at the bottom.
    let g:undotree_ShortIndicators = 1 " Times should written in shorthand.

    " Toggle Undo Tree
    nnoremap <silent> <leader>u :UndotreeToggle<CR><C-w><C-h>
endif

" }}}

" Deletion {{{

" Delete to the null register.
nnoremap <leader>d "_d
nnoremap <leader>D "_D
nnoremap <leader>dd "_dd

" }}}

" Registers {{{

" Show all registers in normal mode
nnoremap <silent> <leader>r :registers<CR>

if has('nvim')
    set clipboard+=unnamedplus " Use the system clipboard by default.

    " Settings for the registers.nvim plugin.
    let g:registers_tab_symbol         = '⇥'

    " When yanking, make yanked text flash
    if has('nvim-0.5')
        augroup high_on_yank
            autocmd!
            autocmd TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}
        augroup END
    endif
endif

" }}}

" Spell Checking {{{

" Set default language to English.
set spelllang=en

" Quickly toggle spell check.
nnoremap <silent> <leader>s :setlocal spell!<cr>

" }}}

" }}}

" Development {{{

" Git Integration {{{

" Open fugitive
if has('nvim')
    nnoremap <silent> <leader>g :Git<CR>
endif

" }}}

" Autocommands  {{{

" Vifm help {{{

" Set vifm's help to use the syntax of vim's help file.
augroup vifm
    autocmd!
    autocmd BufRead vifm-help.txt set filetype=help
    autocmd BufRead vifm-help.txt set readonly
    autocmd BufRead vifm-help.txt set modifiable
augroup END

" }}}

" }}}

" Terminal {{{

if has('nvim')
    augroup nvim_term
        autocmd!
        " Disable numbering in all terminal buffers.
        autocmd TermOpen term://* setlocal norelativenumber
        autocmd TermOpen term://* setlocal nonumber

        " Automatically enter insert mode.
        autocmd TermOpen term://* startinsert
    augroup END
endif

" }}}

" REPL {{{

if has('nvim')
    let g:neoterm_default_mod = ':belowright'
endif

" }}}

" }}}

" Auxiliary {{{

" Firenvim {{{

if has('nvim') && has('nvim-0.4')
    " Firenvim should never automatically activate.
    let g:firenvim_config = {
        \ 'globalSettings': {
            \ 'alt': 'all',
            \ '<C-w>': 'noop',
            \ '<C-n>': 'noop',
        \ },
        \ 'localSettings': {
            \ '.*': {
                \ 'selector': 'textarea',
                \ 'takeover': 'never',
                \ 'priority': 0,
            \ }
        \ }
    \ }
endif

if has('nvim') && exists('g:started_by_firenvim')
    " Delete words with alt-backspace, useful of firenvim.
    inoremap <C-BS> <C-w>
    cnoremap <C-BS> <C-w>

    " This should point to an environment variable.
    let g:post_archive_dir='/home/cjpbirkbeck/docs/notes/posts/'

    function! SaveInPostDir()
        let g:current_file_name=expand('%:t')
        execute ':write ' . g:post_archive_dir . g:current_file_name
    endf

    " Write to a file in the notes directory.
    nnoremap <localleader>w :call SaveInPostDir()<CR>

    " After writing to the real buffer, write to the archive directory.
    augroup write_to_archive
        autocmd!
        autocmd BufWritePost * call SaveInPostDir()<CR>
    augroup END
endif

" }}}

" Gnvim {{{

if exists('g:gnvim')
    :colorscheme savanna
endif

" }}}

" Per-directory configuration {{{

" Allows direnv to load additional configuration (which could override
" defaults), allowing for customized per-project configurations

if exists("$EXTRA_VIM")
  for path in split($EXTRA_VIM, ':')
    exec "source ".path
  endfor
endif

" }}}

" }}}
