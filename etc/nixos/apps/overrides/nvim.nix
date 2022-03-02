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
      rev = "967ac3ab4c2a7ee670d5368faac7b53ba2d07b82";
      sha256 = "166fl7il98fkckgp8ld2licbf0f9xqfx06ww93lafz29llmfa4kf";
    };
  };

  # Not much development here anymore
  customPlugins.vim-textobj-variable-segment = pkgs.vimUtils.buildVimPlugin {
    name = "vim-textobj-variable-segment";
    src = pkgs.fetchFromGitHub {
      owner = "julian";
      repo = "vim-textobj-variable-segment";
      rev = "30f7bc94bc8a87d923631f5e440200b662becb1a";
      sha256 = "1168qylhs0f0xzvy68kh07p8w01ypc78h2cb4pklv8079c869k30";
    };
  };

  # Not much development here anymore
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
      rev = "668b350ce88cc9a2257644c67945c9abbdd36cb5";
      sha256 = "0ngfiv0vi455pszpcf3isxaynj1bppb95k889y14n90fas4ngrkv";
    };
  };

  customPlugins.range-highlight = pkgs.vimUtils.buildVimPlugin {
    name = "range-highlight";
    src = pkgs.fetchFromGitHub {
      owner = "winston0410";
      repo = "range-highlight.nvim";
      rev = "8b5e8ccb3460b2c3675f4639b9f54e64eaab36d9";
      sha256 = "1yswni0p1w7ja6cddxyd3m4hi8gsdyh8hm8rlk878b096maxkgw1";
    };
  };

  customPlugins.cmd-parser_nvim = pkgs.vimUtils.buildVimPlugin {
    name = "cmd-parser_nvim";
    src = pkgs.fetchFromGitHub {
      owner = "winston0410";
      repo = "cmd-parser.nvim";
      rev = "70813af493398217cb1df10950ae8b99c58422db";
      sha256 = "0rfa8cpykarcal8qcfp1dax1kgcbq7bv1ld6r1ia08n9vnqi5vm6";
    };
  };

  # customPlugins.nvim-gdb = pkgs.vimUtils.buildVimPlugin {
  #   name = "nvim-gdb";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "sakhnik";
  #     repo = "nvim-gdb";
  #     rev = "c2a0d076383b8a0991681c33efe80bcba6dd3608";
  #     sha256 = "19yc51bhfaw53rc9awdr145i8k2i2gnnl3faw85afsqs9dr4hi7i";
  #   };
  # };

  neovim_configuration = {
    customRC = ''
      " Let neovim know it is using plugins install with Nix.
      let g:is_nixos = 1

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
        nvim-colorizer-lua           # Show various colour words (e.g. 'Black' or #87fe8e) in that colour.
        registers-nvim               # Dynamically show register contents
        undotree                     # Visualize vim's undos with a tree.
        vim-characterize             # Display Unicode character metadata.
        vim-lastplace                # Open files with cursor at last cursor position.
        vim-signature                # Displays marks in the gutter.
        vim-unimpaired               # Miscellaneous bracket pairings.

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
        vim-endwise                  # Adds ending elements for various structures.

        # Git integration
        gitsigns-nvim                # Shows Git changes in gutter.
        fugitive                     # Git frontend for Vim.

        # IDE-like plugins
        ultisnips                    # Snippet manager.
        vim-snippets                 # Collection of prebuilt snippets.
        nvim-treesitter              # Supports tree-sitter within nvim.
        nvim-treesitter-textobjects  # Add text objects for tree-sitter objects.
        nvim-lspconfig               # Quick configuration of native LSP
        vim-test                     # Automatic testing.
        ale                          # Multi-language linter.
        neoterm                      # Terminal improvements, in particular RELP support

        # Filetype specific plugins
        vim-go                       # Plugin for extra support with Go
        vim-markdown                 # Extra markdown support
        vim-tmux                     # Adds support for modifying tmux config files.
        vim-nix                      # Adds nix syntax colouring and file detection to vim.
        vim-toml                     # Add syntax support for toml files
        vim-orgmode                  # Add support for org file.
        zig-vim                      # Add support for the Zig language.

        # Misc
        firenvim                     # Inserts neovim into browser text boxes.
      ];
      # For optional plugins, loaded only when meeting certain conditions:
      # e.g. autocmd FileType foo :packadd fooCompletion
      opt = [
        glow-nvim                    # Previews for markdown with the terminal
        vim-speeddating              # Increment dates and times.
        emmet-vim                    # Support for writing HTML/CSS
        nvim-gdb                     # Wrapper for C, C++, python and bash debuggers.
        nvim-dap                     # Adapter for the DAP for debugging.
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
