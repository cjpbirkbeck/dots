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
in {
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    neovim_with_plugins = neovim.override {
      configure = {
        customRC = ''
          " Enable ale completetions
          let g:ale_completion_enabled = 1

          " common.vim should hold all the settings to be used across all systems.
          source $HOME/.config/nvim/init.vim

          " Add NixOS' of the GNU collection's dictionaries to nvim's dictionaries list.
          " Useful for autocompletions.
          set dictionary+=${pkgs.miscfiles}/share/web2,${pkgs.miscfiles}/share/web2a
        '';
        packages.neovim = with pkgs.vimPlugins // customPlugins; { start = [
            # Modifies operations and text objects.
            surround            # Manipulate elements that surround text elements.
            ReplaceWithRegister # Replace text objects with register contents directly.
            commentary          # Toggles commenting for a given series of lines.
            vim-swap            # Swap elements
            vim-indent-object   # Manipulate lines of same indentation as a single object.
            argtextobj-vim      #
            vim-visualstar      # Allows */# operators to use arbitrarily defined text.
            vim-easy-align      # Align text elements.
            vim-speeddating     # Increment dates and times
            endwise-vim         # Adds ending elements to various elements
            vim-charazterize    # Show Unicode character metadata
            undotree            # Visual undotree
            neoterm             # Neovim terminal enhancements
            vim-lastplace

            # Fuzzy finding
            fzfWrapper          # Fuzzy finding with fzf
            fzf-vim             # Collection of commands using fzf

            # Advanced editing tools
            gitgutter      # Shows git differences in line.
            fugitive       # Git frontend for vim
            ultisnips      # Snippet manager
            vim-snippets   # Collection of prebuilt snippets.
            vim-test       # Automatic testing.
            # ncm2           # Autocompletion
            # ncm2-bufword   # Suggestion words for currently opened buffers
            # ncm2-path      # Generates suggestions from paths
            # ncm2-ultisnips # Generates suggestions from snippets

            # Syntax colouring and file detection
            vim-nix                # Adds nix syntax colouring and file detection to vim.
            vim-orgmode            # Add support for org file.
            customPlugins.tmux-vim # Adds support for modifying tmux config files.
          ];
          opt = [
            ale            # Multi-language linter.
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
