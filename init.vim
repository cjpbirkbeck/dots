"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                             "
" INIT.VIM                                                                    "
" For most OS'es, this file will initalize the editor and mangae plugins.     "
" For NixOS and Guix System(?), the plugins are managed by the OS             "
" For all others, I am using vim plug for plugin management.                  "
"                                                                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin(stdpath('data') . '/vim-plug')
" Interface enhancements
plug 'itchyny/lightline'        " Lightweight but pretty statusline.
plug 'farmergreg/vim-lastplace' " Open files with cursor at last cursor position.
plug 'tpope/vim-characterize '  " Display Unicode character metadata.
plug 'ap/vim-css-color'         " Displays hex codes in the colour they are describing.
plug 'kshenoy/vim-signature'    " Displays marks in the gutter.
plug 'mbbill/undotree'          " Visual Vim's undos with a tree.
plug 'kassio/neoterm'           " Neovim terminal enhancements.

" Custom operators
plug 'tpope/surround'                  " Manipulate elements that surrounds text, like brackets or quotation marks.
plug 'vim-scripts/ReplaceWithRegister' " Replace text objects with register contents directly.
plug 'tpope/commentary'                " Toggles commenting.
plug 'machakann/vim-swap'              " Swap elements of list structures.
plug 'tpope/vim-repeat'                " Repeat compatible custom operators.

" Custom text objects
plug 'kana/vim-textobj-user'               " Easily create your own text objects
plug 'Julian/vim-textobj-brace'            " Generic braces text objects
plug 'Julian/vim-textobj-variable-segment' " Snake/CamelCase text objects
plug 'gilligan/textobj-gitgutter'          " Git Gutter text objects
plug 'michealjsmith/vim-indent-object'     " Manipulate lines of same indentation as a single object.
plug 'vim-scripts/argtextobj-vim'          " Text object for function arguments.

" Other text manipulation
plug 'thinca/vim-visualstar'   " Allows */# keys to use arbitrarily defined text (with visual mode).
plug 'junegunn/vim-easy-align' " Align text elements some characters.
plug 'tpope/vim-speeddating' " Increment dates and times.
plug 'tpope/endwise-vim'     " Adds ending elements for various structures.

" Fuzzy finding
plug 'junegunn/fzfWrapper' " Fuzzy finding with fzf.
plug 'junegunn/fzf-vim'    " Collection of commands using fzf.

" Git integration
plug 'airblade/gitgutter' " Shows Git changes in gutter.
plug 'tpope/fugitive'     " Git frontend for Vim

" IDE-like plugins
plug 'SirVer/ultisnips'    " Snippet manager.
plug 'honza/vim-snippets'  " Collection of prebuilt snippets.
plug 'ncm2/ncm2'           " Autocompletion
plug 'ncm2/ncm2-bufword'   " Suggestion words for currently opened buffers
plug 'ncm2/ncm2-path'      " Generates suggestions from paths
plug 'ncm2/ncm2-ultisnips' " Generates suggestions from snippets
plug 'janko/vim-test'      " Automatic testing.
plug 'dense-analysis/ale'  " Multi-language linter.

" Filetype specific plugins
plug 'LnL7/vim-nix'           " Adds nix syntax colouring and file detection to vim.
plug 'vLnL7/im-orgmode'       " Add support for org file.
plug 'customPlugins.tmux-vim' " Adds support for modifying tmux config files.
call plug#end()

source $HOME/.config/nvim/common.vim
