"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                             "
" COMMON.VIM                                                                  "
" Holds all commands and settings to be used across all OS'es at all times.   "
" For NixOS and Guix System(?), the plugins are managed by the OS             "
" For all others, I am using vim plug for plugin management.                  "
"                                                                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Functions {{{

" }}}

" Prelude {{{

set modelines=0                              " Modelines set to 0.
set nomodeline                               " Turns off modelines for security.
if has('nvim')
    set shada=!,'100,<50,s10,h,%,r/run/media " Sets the shada settings
    set inccommand=nosplit                   " Show the incremental effects of typing in an command.
    set clipboard+=unnamedplus               " Use the system clipboard by default.
endif
filetype indent plugin on                    " Detect file types.

" Set leader to spacebar.
let mapleader=" "

" Set localleader to backslash.
let maplocalleader="\\"

" }}}

" Interface {{{

" General {{{

set title                      " Set title of terminal.
set number                     " Prints the line numbers on the left margin.
set relativenumber             " Prints the relative line numbers on the left margin.
set showmatch                  " Prints the matching bracket.
set showmode                   " Do not print non-normal mode status.
set lazyredraw                 " Does not redraws screen during operations.
set confirm                    " Prints a confirmation command.
set scrolloff=3                " Cursor will always be 3 lines above or below the screen margins.
set list                       " Show tabs and EOL.
set wildmenu                   " Use the advanced 'wildcard' menu for completion.
set wildmode=longest,list,full " Complete to longest string, list all matches, complete to next fullest match.
set mouse=a                    " Allow mouse usage in all modes.
set wrap                       " Turns on word wrap.

" }}}

" Appearance {{{

syntax enable                   " Enable syntax colouring.
set termguicolors               " Use the true (24-bit) colours instead of the terminal options.
colorscheme cjpb-desert         " Use this theme, with the following modifications.

" Changes cursor shape depending on the current mode.
" Normal mode     = box
" Insert mode     = line
" Overstrike mode = underline
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
 \,a:blinkwait700-blinkoff400-blinkon250
 \,sm:block-blinkwait175-blinkoff150-blinkon175

" }}}

" Status Line {{{

set laststatus=2                " Keeps the status bar on screen.

" Setup lightline
let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' },
    \ 'active': {
    \   'left': [ [ 'mode', ],
    \             [ 'bufnum', 'modified', 'absolutepath' ] ],
    \   'right': [ [ 'charvaluehex', 'percentwin', 'cursorpos' ],
    \              [ 'fileformat', 'fileencoding', 'filetype', 'spell' ] ]
    \ },
    \ 'inactive': {
    \   'left': [ [ 'bufnum' ], [ 'filename' ] ],
    \   'right': [ [ 'percentwin', 'cursorpos' ] ]
    \ },
    \ 'component': {
    \   'cursorpos': '%l:%c/%L'
    \ }
    \ }

if has('win32')
    let g:lightline.separator = { 'left': '', 'right': '' }
    let g:lightline.subseparator = { 'left': '|', 'right': '|' }
endif

" }}}

" Windows {{{

" Sets Control + h/j/k/l to move across windows.
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" }}}

" Files {{{

" Map double leader (double space) to save but not quit.
map <leader><leader> :w<CR>

" Expand the path of the current file within command mode.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Vim already has some 'fuzzy' finding ablities on its own, so let's use them
" here. This is for finding files in the current directory.
nnoremap <leader>f :find<space>

" Set path to search the current directory and any of its subdirectories
" recursively.
set path=.,,**

" Settings for netrw, vim's native file explorer.
let g:netrw_banner = 0       " Do not open with the banner.
let g:netrw_liststyle = 3    " Uses a tree format by default.
let g:netrw_browse_split = 4 " When pressing return on an item, it opens in the previous window.
let g:netrw_winsize = 25     " Specifies netrw default size.
let g:netrw_dirhistmax = 0   " Please does not liter my directories with .netrwhist files; thank you.

" Open netrw in a sidebar.
nnoremap <leader>e :UndotreeHide<CR>:Lexplore<CR>

" }}}

" Buffers {{{

" Navigational shortcuts for moving between buffers.
nnoremap <silent>[b :bprevious<CR>
nnoremap <silent>]b :bnext<CR>
nnoremap <silent>[B :bfirst<CR>
nnoremap <silent>]B :blast<CR>

" Open list of buffers, then search currently open buffers
nnoremap <leader>b :buffers<CR>:b<space>

" }}}

" }}}

" Editing {{{

" Basic {{{

" Disable entering Ex mode, it's unneeded now.
" Remap Q to repeat the last macro.
nnoremap Q @@

" Remap gQ to repeat the last macro.
nnoremap gQ @@

" }}}

" Movement {{{

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

" }}}

" Insertion {{{

" Tabbing and indenting
set smartindent  " Turns on smart-indenting.
set expandtab    " Replaces default tab with number of spaces.
set shiftwidth=4 " Set the number of space for each indent.

" Insert brackets and quotation marks with their matching pair.
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap { {}<ESC>i
inoremap " ""<ESC>i

" Either insert pairs for punctation that can, but normally isn't used for
" pairs, or insert a opening bracket with the matching pair.
inoremap <A-(> (
inoremap <A-[> [
inoremap <A-{> {
inoremap <A-<> <><ESC>i
inoremap <A-'> ''<ESC>i
inoremap <A-"> "
inoremap <A-`> ``<ESC>i

" Insert blank lines above or below the current line.
nnoremap <leader>o m`A<CR><ESC>``
nnoremap <leader>O m`ko<ESC>``

" }}}

" Undos {{{

set undofile " Keep persistent undos.
let g:undotree_WindowLayout = 2
let g:undotree_ShortIndicators = 1

" Toggle Undo Tree
nnoremap <leader>u :UndotreeToggle<CR><C-w><C-h>

" }}}

" Registers {{{

" Remap Y to y$
nnoremap Y y$

" Delete to the null register.
nnoremap <leader>d "_d
nnoremap <leader>D "_D
nnoremap <leader>dd "_dd

" }}}

" Miscellaneous {{{

" Switch between relative and absolute line numbering.
map <leader>n :set relativenumber!<CR>

" Open fugitive
nnoremap <leader>g :Gstatus<CR>

" Map the alignment plugins
nmap gl <Plug>(EasyAlign)
xmap gl <Plug>(EasyAlign)

" }}}

" }}}

" Spell Check {{{

" Quickly toggle spell check.
map <silent> <leader>s :setlocal spell!<cr>

" }}}

" Snippets {{{

let g:UltiSnipsExpandTrigger="<a-j>"
let g:UltiSnipsListSnippets="<a-S-j>"

let g:UltiSnipsJumpForwardTrigger="<a-j>"
let g:UltiSnipsJumpBackwardTrigger="<a-k>"

let g:UltiSnipsSnippetDirectories=["UltiSnips", "snips"]

" }}}

" Autocompletion {{{

" Enable the Ncm2 completion engine, only for neovim only
" if has('nvim') && has('unix')
"     autocmd BufEnter * call ncm2#enable_for_buffer()
" endif

" Autocompletion should never insert nor select a suggestion until the user choose an option.
" Also should always show a menu, even if there is only one choice.
set completeopt=menu,preview,noinsert,menuone,noselect
" Enable omni-completion.
setlocal omnifunc=syntaxcomplete#Complete
" When using generic autocompletion, also get suggestions from the spelling dictionary.
set complete+=kspell

" }}}

" Autocommands  {{{

" Vim-like Programs {{{
augroup vifm
    autocmd!
    autocmd BufRead */vifmrc set filetype=vim
    autocmd BufRead */vimpcrc set filetype=vim
augroup END
" }}}

" augroup govim
"     autocmd!
"     autocmd FileType go :packadd vim-go
" augroup END

" }}}

" {{{ Direnv integration

" Allows direnv to load additional configuration (which could override
" defaults), allowing for customized per-project configurations

if exists("$EXTRA_VIM")
  for path in split($EXTRA_VIM, ':')
    exec "source ".path
  endfor
endif

" }}}
