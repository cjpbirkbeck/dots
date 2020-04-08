" This file is for loading vim with my prefered settings, but without plugins.
" For situtation where I've only got vanilla vim here.

set nocompatable

set modelines=0                          " Modelines set to 0.
set nomodeline                           " Turns off modelines for security.
set shada=!,'100,<50,s10,h,%,r/run/media " Sets the shada settings
set inccommand=nosplit                   " Show the incremental effects of typing in an command.
set clipboard+=unnamedplus               " Use the system clipboard by default.
filetype indent plugin on                " Detect file types.

" Set leader to spacebar.
let mapleader=" "

" Set localleader to backslash.
let maplocalleader="\\"

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
set wildmode=longest,list,full " Complete to longest string, list all match, complete to next fullest match.
set mouse=a                    " Allow mouse usage in all modes.
set wrap                       " Turns on word wrap.

syntax enable                   " Enable syntax colouring.
set termguicolors               " Use the true (24-bit) colours instead of the terminal options.
colorscheme desert              " Use this theme, with the following modifications.

" Italize comments
highlight Comment gui=italic

" Make the mispelling indicator more visible.
highlight SpellBad guisp=LightRed

" Change the status colours.
highlight StatusLine gui=bold guibg=#E29E38 guifg=black
highlight StatusLineNC gui=bold

highlight User1 gui=bold guifg=Black guibg=LightBlue
highlight User2 gui=bold guifg=Black guibg=LightGreen

" Status line
set statusline=%1*[%n]
set statusline+=\ %f
set statusline+=\ %m
set statusline+=\ %y%*
set statusline+=%=
set statusline+=%2*[%{&fileformat}\ %{&fileencoding?&fileencoding:&encoding}]
set statusline+=\ {%B}
set statusline+=\ %l:%c/%L
set statusline+=\ %P

" Sets Control + h/j/k/l to move across windows.
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Map double leader to save but not quit.
map <leader><leader> :w<CR>

" Quickly change working directory.
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

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

" Navigational shortcuts for moving between buffers.
nnoremap <silent>[b :bprevious<CR>
nnoremap <silent>]b :bnext<CR>
nnoremap <silent>[B :bfirst<CR>
nnoremap <silent>]B :blast<CR>

" Open list of buffers, then search currently open buffers
nnoremap <leader>b :buffers<CR>:b<space>

