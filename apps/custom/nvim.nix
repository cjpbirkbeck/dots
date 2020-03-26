# Configuration for neovim and related programs.
# Here, I am installing vim plugins with nix, which may require manually specifying its location if not in nixpkgs.
# Most of the actual configuration is kept seperate in common.vim.

{ config, pkgs, ... }:

let
  unstable = import <unstable> {};

  customPlugins.tmux-vim = pkgs.vimUtils.buildVimPlugin {
    name = "tmux.vim";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "vim-tmux";
      rev = "4e77341a2f8b9b7e41e81e9debbcecaea5987c85";
      sha256 = "16fgc0lx1jr8zbayanf5w677ssiw5xb8vwfaca295c8xlk760c3m";
    };
  };

  customPlugins.vim-swap = pkgs.vimUtils.buildVimPlugin {
    name = "vim-swap";
    src = pkgs.fetchFromGitHub {
      owner = "machakann";
      repo = "vim-swap";
      rev = "e52ff679c88f4aa7a7afe77fb42af78c93ed33c8";
      sha256 = "0rqvxqqk961syawmyc2qdfb4w9ilb1r3mxxij2ja1jbhl1f3w4vq";
    };
  };

  customPlugins.endwise-vim = pkgs.vimUtils.buildVimPlugin {
    name = "endwise-vim";
    src = pkgs.fetchFromGitHub {
      owner = "tpope";
      repo = "vim-endwise";
      rev = "f67d022169bd04d3c000f47b1c03bfcbc4209470";
      sha256 = "0lq2sphh2mfciva184b4b3if202hr4yls4d2gzbjx7ibch45zb9i";
    };
  };

  customPlugins.vim-charazterize = pkgs.vimUtils.buildVimPlugin {
    name = "charazterize-vim";
    src = pkgs.fetchFromGitHub {
      owner = "tpope";
      repo = "vim-characterize";
      rev = "c6d26e5017ab8637bac30db7448ddabfaa238cce";
      sha256 = "119k93k55r3r8lsz5chjwyww8pjxqajv4r8ccb82zxfpg4fffkcv";
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

in {
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    neovim_with_plugins = neovim.override {
      configure = {
        customRC = ''
          " common.vim should hold all the settings to be used across all systems.
          source $HOME/.config/nvim/common.vim

          " Add NixOS' of the GNU collection's dictionaries to nvim's dictionaries list.
          " Useful for autocompletions.
          set dictionary+=${pkgs.miscfiles}/share/web2,${pkgs.miscfiles}/share/web2a
        '';
        packages.neovim = with pkgs.vimPlugins // customPlugins; { start = [
            # Basic plugins: Test plugins extends what is arguably the core of vim,
            # working text with {operator}{motion/text object}.
            # Custom operators
            surround            # Manipulate elements that surround text elements.
            ReplaceWithRegister # Replace text objects with register contents directly.
            commentary          # Toggles commenting for a given series of lines.
            vim-swap            # Swap elements of element.
            repeat              # Repeat custom operators.

            # Custom text objects
            vim-textobj-user             # Easily create your own text objects
            vim-textobj-brace            # Generic braces text objects
            vim-textobj-variable-segment # Snake/CamelCase text objects
            textobj-gitgutter            # Git Gutter text objects
            vim-indent-object            # Manipulate lines of same indentation as a single object.
            argtextobj-vim               # Text object for function arguments.

            # Other text manipulation plugins
            vim-visualstar      # Allows */# operators to use arbitrarily defined text (with visual mode).
            vim-easy-align      # Align text elements.
            vim-speeddating     # Increment dates and times.
            endwise-vim         # Adds ending elements to various elements.

            # Some interface tools
            vim-charazterize    # Show Unicode character metadata.
            undotree            # Visual undotree.
            neoterm             # Neovim terminal enhancements.
            vim-lastplace       # Open files with cursor at closing position.

            # Fuzzy finding
            fzfWrapper          # Fuzzy finding with fzf.
            fzf-vim             # Collection of commands using fzf.

            # Tools for working with git.
            gitgutter           # Shows git differences in line.
            fugitive            # Git frontend for vim

            # IDE-like plugins
            ultisnips           # Snippet manager.
            vim-snippets        # Collection of prebuilt snippets.
            vim-test            # Automatic testing.
            ale                 # Multi-language linter.

            # Filetype specific plugins
            vim-nix                # Adds nix syntax colouring and file detection to vim.
            vim-orgmode            # Add support for org file.
            customPlugins.tmux-vim # Adds support for modifying tmux config files.
          ];
          opt = [
            ncm2                  # Autocompletion
            ncm2-bufword          # Suggestion words for currently opened buffers
            ncm2-path             # Generates suggestions from paths
            ncm2-ultisnips        # Generates suggestions from snippets
            LanguageClient-neovim # Language server client for neovim
          ];
        };
      };
    };

    neovim-qt_with_plugins = neovim-qt.override {
      neovim = neovim_with_plugins;
    };
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.shellAliases = {
    vi    = "nvim";
    vim   = "nvim";
    view  = "nvim -R";
  };

  environment.systemPackages = with pkgs; [
    neovim_with_plugins    # Customized neovim.
    neovim-qt_with_plugins # GUI frontend using Qt.
    neovim-remote          # Control remote instances of neovim.

    miscfiles              # Misc files have a dictionary list that is useful to vim autocompletions.
    universal-ctags        # Tags file that will hold keyword information.
  ];
}
