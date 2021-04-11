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

  customPlugins.sonokai = pkgs.vimUtils.buildVimPlugin {
    name = "sonokai";
    src = pkgs.fetchFromGitHub {
      owner = "sainnhe";
      repo = "sonokai";
      rev = "78f1b14ad18b043eb888a173f4c431dbf79462d8";
      sha256 = "0spnpzr874ad9jpawcgydfm242wq55ychcky14f1qa09svsrdiv0";
    };
  };

  customPlugins.vim-characterize = pkgs.vimUtils.buildVimPlugin {
    name = "vim-characterize";
    src = pkgs.fetchFromGitHub {
      owner = "tpope";
      repo = "vim-characterize";
      rev = "af156501e8a8855832f15c2cc3d6cefb2d7f7f52";
      sha256 = "1fmrh94miansi5sz1cwyia7z57azwi4cfxx59h81wrmlsf513l5w";
    };
  };

  customPlugins.vim-textobj-brace = pkgs.vimUtils.buildVimPlugin {
    name = "vim-textobj-brace";
    src = pkgs.fetchFromGitHub {
      owner = "julian";
      repo = "vim-textobj-brace";
      rev = "b936fbd99e16dcc6e4d62d5e81a73d9ad37fd576";
      sha256 = "086z1dnglig006p8gpalf8j94qchqakz1ba7j067alp1pf991jp8";
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

  customPlugins.textobj-gitgutter = pkgs.vimUtils.buildVimPlugin {
    name = "textobj-gitgutter";
    src = pkgs.fetchFromGitHub {
      owner = "gilligan";
      repo = "textobj-gitgutter";
      rev = "4bcaa031fea6cb080e4824e75522273e6090f1b6";
      sha256 = "0gnypaj5ym5j4g6infbbnjac4x74m5n2lvzq1kzc2s192d7x9m6v";
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

in {
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    neovim_with_plugins = neovim.override {
      viAlias = true;
      vimAlias = true;

      extraPython3Packages = (ps: with ps; [ simple-websocket-server python-slugify ]);

      configure = {
        customRC = ''
          " common.vim should hold all the settings to be used across all systems.
          source $HOME/.config/nvim/common.vim

          " Add NixOS' of the GNU collection's dictionaries to nvim's dictionaries list.
          " Useful for autocompletions.
          set dictionary+=${pkgs.miscfiles}/share/web2,${pkgs.miscfiles}/share/web2a
        '';
        packages.neovim = with pkgs.vimPlugins // customPlugins; { start = [
            # Interface enhancements
            lightline-vim       # Lightweight but pretty statusline.
            vim-lastplace       # Open files with cursor at last cursor position.
            vim-characterize    # Display Unicode character metadata.
            vim-signature       # Displays marks in the gutter.
            undotree            # Visual Vim's undos with a tree.
            neoterm             # Neovim terminal enhancements.

            # Custom operators
            surround            # Manipulate elements that surrounds text, like brackets or quotation marks.
            ReplaceWithRegister # Replace text objects with register contents directly.
            commentary          # Toggles commenting.
            vim-swap            # Swap elements of list structures.
            repeat              # Repeat compatible custom operators.

            # Custom text objects
            vim-textobj-user             # Easily create your own text objects
            vim-textobj-brace            # Generic braces text objects
            vim-textobj-comment          # Comment block text objects
            vim-textobj-variable-segment # Snake/CamelCase text objects
            vim-textobj-matchit          # Text object for matchit elements
            textobj-gitgutter            # Git Gutter text objects
            vim-indent-object            # Manipulate lines of same indentation as a single object.
            argtextobj-vim               # Text object for function arguments.

            # Other text manipulation
            vim-visualstar      # Allows */# keys to use arbitrarily defined text (with visual mode).
            vim-easy-align      # Align text elements some characters.
            vim-speeddating     # Increment dates and times.
            vim-endwise         # Adds ending elements for various structures.

            # Fuzzy finding
            fzfWrapper          # Fuzzy finding with fzf.
            fzf-vim             # Collection of commands using fzf.

            # Git integration
            gitgutter           # Shows Git changes in gutter.
            fugitive            # Git frontend for Vim.

            # IDE-like plugins
            ultisnips           # Snippet manager.
            vim-snippets        # Collection of prebuilt snippets.
            LanguageClient-neovim # Language server for neovim
            vim-test            # Automatic testing.
            ale                 # Multi-language linter.

            # Filetype specific plugins
            vim-nix                # Adds nix syntax colouring and file detection to vim.
            vim-tmux               # Adds support for modifying tmux config files.
            vim-go                 # Plugin for extra support with Go
            vim-orgmode            # Add support for org file.
            zig-vim                # Add support for the Zig language

            # External plugins
            vim-ghost

            # Test
            sonokai
          ];
          # For optional plugins, loaded only when meeting certain conditions:
          # e.g. autocmd FileType foo :packadd fooCompletion
          opt = [
            # Stuff
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
