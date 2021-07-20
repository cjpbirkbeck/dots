# Configuration for neovim and related programs.
# Here, I am installing vim plugins with nix, which may require manually specifying its location if not in nixpkgs.
# Most of the actual configuration is kept seperate in common.vim.

{ config, pkgs, ... }:

let
  unstable = import <unstable> {};

  neovim-pkgs = with pkgs; [
    neovim_with_plugins    # Customized neovim.
    neovim-qt_with_plugins # GUI frontend using Qt.
    neovim-remote          # Control remote instances of neovim.

    miscfiles              # Misc files have a dictionary list that is useful for vim autocompletions.
    universal-ctags        # Tags files that will hold keyword information.
  ];

  customPlugins.vim-characterize = pkgs.vimUtils.buildVimPlugin {
    name = "vim-characterize";
    src = pkgs.fetchFromGitHub {
      owner = "tpope";
      repo = "vim-characterize";
      rev = "af156501e8a8855832f15c2cc3d6cefb2d7f7f52";
      sha256 = "1fmrh94miansi5sz1cwyia7z57azwi4cfxx59h81wrmlsf513l5w";
    };
  };

  customPlugins.vim-textobj-variable-segment = pkgs.vimUtils.buildVimPlugin {
    name = "vim-textobj-variable-segment";
    src = pkgs.fetchFromGitHub {
      owner = "julian";
      repo = "vim-textobj-variable-segment";
      rev = "78457d4322b44bf89730e708b62b69df48c39aa3";
      sha256 = "14dcrnk83hj4ixrkdgjrk9cf0193f82wqckdzd4w0b76adf3habj";
    };
  };

  customPlugins.vim-textobj-matchit = pkgs.vimUtils.buildVimPlugin {
    name = "vim-textobj-matchit";
    src = pkgs.fetchFromGitHub {
      owner = "adriaanzon";
      repo = "vim-textobj-matchit";
      rev = "d1cdd34e6b43e18272b570fa32f94467fdd8f3e0";
      sha256 = "1vc435bbxhcc9g062s10whhs7n8b9m1vsqxqq3bmqfmbsbkzq5qh";
    };
    preBuild = "rm Makefile";
  };

  customPlugins.firenvim = pkgs.vimUtils.buildVimPlugin {
    name = "firenvim";
    src = pkgs.fetchFromGitHub {
      owner = "glacambre";
      repo = "firenvim";
      rev = "6e973151f6e30358f13b80cb68a7b2c4727ff3ef";
      sha256 = "1vi508b0wy59rsb9nbzfkcw45nrizxgksz1l4p1ggqmzwaj5iw3f";
    };
  };

in {
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    neovim_with_plugins = unstable.neovim.override {
      viAlias = true;
      vimAlias = true;

      configure = {
        customRC = ''
          " common.vim should hold all the settings to be used across all systems.
          source $HOME/.config/nvim/common.vim

          " Add NixOS' of the GNU collection's dictionaries to nvim's dictionaries list.
          " Useful for autocompletions.
          set dictionary+=${pkgs.miscfiles}/share/web2,${pkgs.miscfiles}/share/web2a

          " Set up colorizer.
          lua require'colorizer'.setup()
        '';
        packages.neovim = with unstable.pkgs.vimPlugins // customPlugins; { start = [
            # Interface enhancements
            lightline-vim                # Lightweight but pretty statusline.
            vim-lastplace                # Open files with cursor at last cursor position.
            vim-characterize             # Display Unicode character metadata.
            vim-signature                # Displays marks in the gutter.
            undotree                     # Visualize vim's undos with a tree.
            neoterm                      # Neovim terminal enhancements.
            nvim-colorizer-lua

            # Custom operators
            surround                     # Manipulate elements that surrounds text, like brackets or quotation marks.
            ReplaceWithRegister          # Replace text objects with register contents directly.
            commentary                   # Operates on comments and comment blocks.
            vim-swap                     # Swap elements of list structures.
            repeat                       # Repeat compatible custom operators.

            # Custom text objects
            vim-textobj-user             # Easily create your own text objects
            vim-textobj-comment          # Comment block text objects
            vim-textobj-variable-segment # Snake/CamelCase text objects
            vim-textobj-matchit          # Text object for matchit elements
            vim-indent-object            # Manipulate lines of same indentation as a single object.
            argtextobj-vim               # Text object for function arguments.

            # Other text manipulation
            vim-visualstar               # Allows */# keys to use arbitrarily defined text (with visual mode).
            vim-easy-align               # Align text elements some characters.
            vim-speeddating              # Increment dates and times.
            vim-endwise                  # Adds ending elements for various structures.

            # Fuzzy finding
            fzfWrapper                   # Fuzzy finding with fzf.
            fzf-vim                      # Collection of commands using fzf.

            # Git integration
            gitgutter                    # Shows Git changes in gutter.
            fugitive                     # Git frontend for Vim.

            # IDE-like plugins
            ultisnips                    # Snippet manager.
            vim-snippets                 # Collection of prebuilt snippets.
            LanguageClient-neovim        # Language server for neovim
            vim-test                     # Automatic testing.
            ale                          # Multi-language linter.

            # Filetype specific plugins
            # Should go into opt, unless it doesn't work.
            vim-go                       # Plugin for extra support with Go
            vim-markdown                 # Extra markdown support

            # Misc
            firenvim                     # Inserts neovim into browser text boxes.
            nvim-treesitter              # Supports tree-sitter within nvim.
            nvim-treesitter-textobjects
          ];
          # For optional plugins, loaded only when meeting certain conditions:
          # e.g. autocmd FileType foo :packadd fooCompletion
          opt = [
            vim-tmux                     # Adds support for modifying tmux config files.
            vim-nix                      # Adds nix syntax colouring and file detection to vim.
            zig-vim                      # Add support for the Zig language
            vim-orgmode                  # Add support for org file.
            emmet-vim                    # Support for writing HTML/CSS
            semshi

          ];
        };
      };
    };

    neovim-qt_with_plugins = unstable.neovim-qt.override {
      neovim = neovim_with_plugins;
    };

    gnvim_with_plugins = gnvim.override {
      neovim = neovim_with_plugins;
    };
  };

  environment = {
    shellAliases = {
      v = "nvim";
      view  = "nvim -R";
      vimdiff = "nvim -d";
    };
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
