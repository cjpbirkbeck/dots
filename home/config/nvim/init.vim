"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                             "
" INIT.VIM                                                                    "
" For most OS'es, this file will initalize the editor and manages plugins.    "
" For NixOS, the plugins are managed by the OS.                               "
" For all others, I am using vim-plug for plugin management.                  "
"                                                                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin(stdpath('data') . '/plugged')
" Interface enhancements
Plug 'itchyny/lightline.vim'               " Lightweight but pretty statusline.
Plug 'farmergreg/vim-lastplace'            " Open files with cursor at last cursor position.
Plug 'tpope/vim-characterize'              " Display Unicode character metadata.
Plug 'kshenoy/vim-signature'               " Displays marks in the gutter.
Plug 'mbbill/undotree'                     " Visual Vim's undos with a tree.
Plug 'kassio/neoterm'                      " Neovim terminal enhancements.

" Custom operators
Plug 'tpope/vim-surround'                  " Manipulate elements that surrounds text.
Plug 'vim-scripts/ReplaceWithRegister'     " Replace text objects with register contents directly.
Plug 'tpope/vim-commentary'                " Toggles commenting.
Plug 'machakann/vim-swap'                  " Swap elements of list structures.
Plug 'tpope/vim-repeat'                    " Repeat compatible custom operators.

" Custom text objects
Plug 'kana/vim-textobj-user'               " Easily create your own text objects
Plug 'Julian/vim-textobj-variable-segment' " Snake/CamelCase text objects
Plug 'adriaanzon/vim-textobj-matchit'      " Matchit text objects
Plug 'michaeljsmith/vim-indent-object'     " Manipulate lines of same indentation as a single object.
Plug 'vim-scripts/argtextobj.vim'          " Text object for function arguments.

" Other text manipulation
Plug 'thinca/vim-visualstar'               " Allows */# keys to used in visual mode.
Plug 'junegunn/vim-easy-align'             " Align text elements some characters.
Plug 'tpope/vim-speeddating'               " Increment dates and times.
Plug 'tpope/vim-endwise'                   " Adds ending elements for various structures.

" Fuzzy finding
Plug 'junegunn/fzf.vim'                    " Collection of commands using fzf.

" Git integration
Plug 'airblade/vim-gitgutter'              " Shows Git changes in gutter.
Plug 'tpope/vim-fugitive'                  " Git frontend for Vim.

" IDE-like plugins
Plug 'SirVer/ultisnips'                    " Snippet manager.
Plug 'honza/vim-snippets'                  " Collection of prebuilt snippets.
Plug 'roxma/nvim-yarp'                     " Remote Plugin framework.
Plug 'autozimu/LanguageClient-neovim'      " Language server implementation.
Plug 'janko/vim-test'                      " Automatic testing.
Plug 'dense-analysis/ale'                  " Multi-language linter.

" Filetype specific plugins
Plug 'LnL7/vim-nix'                        " Adds nix syntax colouring and file detection to vim.
Plug 'jceb/vim-orgmode'                    " Add support for org file.
Plug 'tmux-plugins/vim-tmux'               " Adds support for modifying tmux config files.
Plug 'fatih/vim-go'                        " Extra support for working the Go language.

" Misc
" Allows nvim to run within browsers
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
call plug#end()

if has('win32')
    source $HOME\AppData\Local\nvim\common.vim
    let g:python3_host_prog = 'C:\Python39\python.EXE'
else
    source $HOME/.config/nvim/common.vim
endif
