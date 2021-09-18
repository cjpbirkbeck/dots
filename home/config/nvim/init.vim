"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                             "
" INIT.VIM                                                                    "
" For most OS'es, this file will initalize the editor and manages plugins.    "
" For NixOS, the plugins are managed by the OS and this file is not read.     "
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
Plug 'tpope/vim-unimpaired'                " Miscellaneous bracket pairings.
Plug 'winston0410/cmd-parser.nvim'         " Required for range-highlights.
Plug 'winston0410/range-highlight.nvim'    " Highlights command line ranges.
if has('nvim-0.4')
    Plug 'norcalli/nvim-colorizer.lua'     " Add colours to words like 'Black' and '#2bf211'.
endif
if has('nvim-0.5')
    Plug 'tversteeg/registers.nvim'        " Show registers contents while inserting text.
endif

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
Plug 'tpope/vim-endwise'                   " Adds ending elements for various structures.

" Git integration
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'             " Shows Git changes in gutter.
Plug 'tpope/vim-fugitive'                  " Git frontend for Vim.

" IDE-like plugins
Plug 'SirVer/ultisnips'                    " Snippet manager.
Plug 'honza/vim-snippets'                  " Collection of prebuilt snippets.
Plug 'roxma/nvim-yarp'                     " Remote Plugin framework.
Plug 'janko/vim-test'                      " Automatic testing.
Plug 'kassio/neoterm'                      " Neovim terminal enhancements.
if has('nvim-0.2')
    Plug 'dense-analysis/ale'              " Multi-language linter.
endif
" LSP supports language servers for better go to defintion, etc.
" Tree supports better syntax highlighting, text object based on syntax, etc.
if has('nvim-0.5')
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate' }
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
endif

" Filetype specific plugins
Plug 'LnL7/vim-nix'                        " Adds nix syntax colouring and file detection to vim.
Plug 'jceb/vim-orgmode'                    " Add support for org file.
Plug 'tmux-plugins/vim-tmux'               " Adds support for modifying tmux config files.
Plug 'cespare/vim-toml'
Plug 'ziglang/zig.vim'
Plug 'plasticboy/vim-markdown'
if has('nvim-0.5')
    Plug 'fatih/vim-go'                    " Extra support for working the Go language.
endif

" Misc
if has('nvim-0.5')
    " Allows nvim to run within browsers
    " Keep this for windows version only now.
    if has('win32')
        Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
    endif
endif

" Optional plugins
" Use an empty array so vim-plug install but does not load it,
" using ftplugins files and autocommands to do that for us.
Plug 'ellisonleao/glow.nvim', {  'for': [] }
Plug 'tpope/vim-speeddating', {  'for': [] } " Increment dates and times.
Plug 'mattn/emmet-vim', {  'for': [] }
Plug 'sakhnik/nvim-gdb', {  'for': [] }
Plug 'mfussenegger/nvim-dap', {  'for': [] }
call plug#end()

if has('win32')
    source $HOME\AppData\Local\nvim\common.vim
    let g:python3_host_prog = 'C:\Python39\python.EXE'
    lua require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }
else
    source $HOME/.config/nvim/common.vim
endif

if has('nvim') && has('nvim-0.5')
    lua require'colorizer'.setup()
endif
