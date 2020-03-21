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

set modelines=0                          " Modelines set to 0.
set nomodeline                           " Turns off modelines for security.
set shada=!,'100,<50,s10,h,%,r/run/media " Sets the shada settings
set undofile                             " Keep persistent undos.
set inccommand=nosplit                   " Show the incremental effects of typing in an command.
set clipboard+=unnamedplus               " Use the system clipboard by default.
filetype indent plugin on                " Detect file types.

" Set leader to spacebar.
let mapleader=" "

" Set localleader to Control+Spacebar.
let maplocalleader="\\"

" }}}

" Interface {{{

" General {{{

set title                      " Set title of terminal.
set number                     " Prints the line numbers on the left margin.
set relativenumber             " Prints the relative line numbers on the left margin.
set showmatch                  " Prints the matching bracket.
set showmode                   " Prints non-normal mode status.
set lazyredraw                 " Does not redraws screen during operations.
set confirm                    " Prints a confirmation command.
set scrolloff=3                " Cursor will always be 3 lines above or below the screen margins.
set list                       " Show tabs and EOL.
set wildmenu                   " Use the advanced 'wildcard' menu for completion.
set wildmode=longest,list,full " Complete to longest string, list all match, complete to next fullest match.
set mouse=a                    " Allow mouse usage in all modes.
set wrap                       " Turns on word wrap.

" }}}

" Appearance {{{

syntax enable                   " Enable syntax colouring.
set termguicolors               " Use the true (24-bit) colours instead of the terminal options.
colorscheme desert

" Italize comments
highlight Comment gui=italic

" Changes cursor shape depending on the current mode.
" Normal mode     = box
" Insert mode     = line
" Overstrike mode = line
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
 \,a:blinkwait700-blinkoff400-blinkon250
 \,sm:block-blinkwait175-blinkoff150-blinkon175

" }}}

" Status Line {{{

set laststatus=2                " Keeps the status bar on screen.

" Change the status colours.
highlight StatusLine gui=bold guibg=#E29E38 guifg=black
highlight StatusLineNC guifg=black

" Status line
set statusline=[%n]\ %f\ %m\ %y\ %h\ %r\ %=\ [%{&fileformat}\ %{&fileencoding?&fileencoding:&encoding}\]\ {%B}\ %P\ %l/%L:%c

" }}}

" Windows {{{

" Sets Control + h/j/k/l to move across windows.
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" }}}

" Files {{{

" Map double leader to save but not quit.
map <leader><leader> :w<CR>

" Quickly change working directory.
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" Expand the path of the current file within command mode.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Vim already has some 'fuzzy' finding ablities on its own, so let's use them
" here. This is for finding files in the current directory.
nnoremap <leader>f :find 

" Here, use fzf to fuzzy find files find throughout the home directory.
nnoremap <leader>z :Files ~<CR>

" Set path to search the current directory and any of its subdirectories
" recursively.
set path=.,**

" Settings for netrw, vim's native file explorer.
let g:netrw_banner = 0       " Do not open with the banner.
let g:netrw_liststyle = 3    " Uses a tree format by default.
let g:netrw_browse_split = 4 " When pressing return on an item, it opens in the previous window.
let g:netrw_winsize = 25     " Specifies netrw default size.

" }}}

" Buffers {{{

" Navigational shortcuts for moving between buffers.
nnoremap <silent>[b :bprevious<CR>
nnoremap <silent>]b :bnext<CR>
nnoremap <silent>[B :bfirst<CR>
nnoremap <silent>]B :blast<CR>

" Search currently open buffers
nnoremap <leader>b :Buffers<CR>

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

set ignorecase                  " Ignores case in searches.
set smartcase                   " Enables case-sensitivity with uppercase characters.
set infercase                   " Will match cases in auto-completions.

" Clear search highlighting.
nnoremap <leader><CR> :nohlsearch<CR>

" }}}

" Insertion {{{

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
nnoremap <leader>o :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <leader>O :set paste<CR>m`O<Esc>``:set nopaste<CR>

" }}}

" Registers {{{

" Remap Y to y$
nnoremap Y y$

" Delete to the null register.
nnoremap <leader>d "_d
nnoremap <leader>D "_D
nnoremap <leader>dd "_dd

" " Copy and paste from the system clipboard
" nnoremap <leader>y "+y
" nnoremap <leader>Y "+Y
" nnoremap <leader>yy "+yy

" nnoremap <leader>d "+d
" nnoremap <leader>D "+D
" nnoremap <leader>dd "+dd

" nnoremap <leader>p "+p
" nnoremap <leader>P "+P

" vnoremap <leader>p "+p
" vnoremap <leader>y "+y
" vnoremap <leader>d "+d

" }}}

" Tabs {{{

set smartindent                  " Turns on smart-indenting.
set expandtab                    " Replaces default tab with number of spaces.
set shiftwidth=4                 " Set the number of space for each indent.

" }}}

" Miscellaneous {{{

" Switch between relative and absolute line numbering.
map <leader>n :set relativenumber!<CR>

" Open fugitive
nnoremap <leader>g :Gstatus<CR>

" Remap ga to gA
nnoremap gA ga

" Map the alignment plugins
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" }}}

" }}}

" Search {{{

" Fuzzy Finding {{{

" Set actions that fzf can do.
let g:fzf_action = {
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Fzf layout
let g:fzf_layout = { 'down': '~25%' }

" Set neovim's colours as fzf's colours
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" History for fzf
let g:fzf_history_dir = '~/.local/share/fzf'

" }}}

" }}}

" Spell Check {{{

" Quickly toggle spell check.
map <leader>s :setlocal spell!<cr>

" }}}

" Snippets {{{

nnoremap <leader>html :-1read ./templates/blank.html<CR>3jwf>a

let g:UltiSnipsExpandTrigger="<a-j>"
let g:UltiSnipsJumpForwardTrigger="<a-j>"
let g:UltiSnipsJumpBackwardTrigger="<a-k>"

" }}}

" Linting and Autocompletion {{{

autocmd BufEnter * :packadd ale

" Autocompletion should never insert nor select a suggestion until the user choose an option.
" Also should always show a menu, even if there is only one choice.
set completeopt=menu,preview,noinsert,menuone,noselect
" Enable omni-completion.
set omnifunc=ale#completion#OmniFunc
" When using generic autocompletion, also get suggestions from the spelling dictionary.
set complete+=kspell

" }}}

" Autocommands  {{{

" Templates {{{
" Automatically populate new files with templates.
augroup templates
    autocmd!
    autocmd BufNewFile /etc/nixos/*.nix 0r $HOME/.config/nvim/templates/nixos.nix
    autocmd BufNewFile *.html,*.htm 0r $HOME/.config/nvim/templates/blank.html
augroup END

" }}}

" i3 config file {{{
augroup i3config
    autocmd!
    autocmd BufRead */i3/config* set filetype=i3config
augroup END
" }}}

" AwesomeWM config file {{{

" Automatically set folding for the awesomeWM with marker.
augroup awesomeWM
    autocmd!
    autocmd BufRead */awesome/rc.lua set foldmethod=marker
augroup END
" }}}

" Vifm config file {{{
augroup vifm
    autocmd!
    autocmd BufRead */vifmrc set filetype=vim
augroup END
" }}}

" Vimscript {{{

" Reverse how double quotes are used, as vimscript uses a double quote as a
" comment character.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim inoremap <buffer> " "
    autocmd FileType vim inoremap <buffer> <A-"> ""
augroup END
" }}}

" Nix language {{{

" Auto-insert brackets with a semi-colon.
augroup nixos
    autocmd!
    autocmd FileType nix inoremap <buffer> [ [];<ESC>hi
    autocmd FileType nix inoremap <buffer> <A-[> [
    autocmd FileType nix inoremap <buffer> { {};<ESC>hi
    autocmd FileType nix inoremap <buffer> <A-{> {
augroup END

" }}}

" Python {{{
augroup py_files
    autocmd!
    autocmd FileType python setlocal foldmethod=syntax
augroup END
" }}}

" }}}
