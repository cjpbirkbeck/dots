# Configuration for neovim and related programs.
# Here, I am installing vim plugins with nix, which may require manually specifying its location if not in nixpkgs.
# Most of the actual configuration is kept seperate in common.vim.

{ config, pkgs, ... }:

let
  unstable = import <unstable> {};

  makeTSParserOption = lang:
    "parser/" + lang + ".so";

  makeTSParserPath = lang:
  let
    pkgPathForTSParser = "\${pkgs.tree-sitter.builtGrammars.tree-sitter-" + lang "}";
  in
    "${pkgPathForTSParser}/path";

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

  # This should update every once and while.
  customPlugins.firenvim = pkgs.vimUtils.buildVimPlugin {
    name = "firenvim";
    src = pkgs.fetchFromGitHub {
      owner = "glacambre";
      repo = "firenvim";
      rev = "da665b10bd528e62ba68978b38b17183a4aa8da5";
      sha256 = "158dak0wddcjxil3sj26zn130c6xlz6n093gri7j5q85jdka9zv8";
    };
  };

  neovim_configuration = {
    customRC = ''
      " common.vim should hold all the settings to be used across all systems.
      source $HOME/.config/nvim/common.vim

      " Add NixOS' of the GNU collection's dictionaries to nvim's dictionaries list.
      " Useful for autocompletions.
      set dictionary+=${pkgs.miscfiles}/share/web2,${pkgs.miscfiles}/share/web2a

      " Set up colorizer.
      lua require'colorizer'.setup()
    '';
    packages.neovim = with unstable.pkgs.vimPlugins // customPlugins; {
      start = [
        # Interface enhancements
        lightline-vim                # Lightweight but pretty statusline.
        vim-lastplace                # Open files with cursor at last cursor position.
        vim-characterize             # Display Unicode character metadata.
        vim-signature                # Displays marks in the gutter.
        undotree                     # Visualize vim's undos with a tree.
        neoterm                      # Neovim terminal enhancements.
        nvim-colorizer-lua           # Show various colour words (e.g. 'black' or #87fe8e) in that colour.
        registers-nvim               # Dynamically show register contents

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
        neorg

        # Misc
        firenvim                     # Inserts neovim into browser text boxes.
        nvim-treesitter              # Supports tree-sitter within nvim.
        nvim-treesitter-textobjects
      ];
      # For optional plugins, loaded only when meeting certain conditions:
      # e.g. autocmd FileType foo :packadd fooCompletion
      opt = [
        emmet-vim                    # Support for writing HTML/CSS
        vim-nix                      # Adds nix syntax colouring and file detection to vim.
        vim-orgmode                  # Add support for org file.
        vim-tmux                     # Adds support for modifying tmux config files.
        zig-vim                      # Add support for the Zig language
      ];
    };
  };
in {
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    neovim_with_plugins = unstable.neovim.override {
      configure = neovim_configuration;
    };

    neovim-qt_with_plugins = unstable.neovim-qt.override {
      neovim = neovim_with_plugins;
    };

    gnvim_with_plugins = unstable.gnvim.override {
      neovim = neovim_with_plugins;
    };

    tree_sitter_with_packages = pkgs.tree-sitter.withPlugins (p: [
      p.tree-sitter-c
      p.tree-sitter-go
    ]);
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    package = unstable.neovim-unwrapped;
    configure = neovim_configuration;
    runtime = {
      "parser/bash.so" = {
        source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-bash}/parser";
      };
      "parser/css.so" = {
        source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-css}/parser";
      };
      "parser/go.so" = {
        source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-go}/parser";
      };
      "parser/html.so" = {
        source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-html}/parser";
      };
      "parser/javascript.so" = {
        source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-javascript}/parser";
      };
      # "parser/lua.so" = {
      #   source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
      # };
      "parser/markdown.so" = {
        source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-markdown}/parser";
      };
      "parser/nix.so" = {
        source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
      };
      "parser/python.so" = {
        source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
      };
      "parser/yaml.so" = {
        source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-yaml}/parser";
      };
    };
  };

  # programs.neovim.runtime = {
  #   "parser/yaml.so".source = (makeTSParserPath "yaml");
  # };
}
