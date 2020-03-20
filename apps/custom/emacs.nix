# Packages to install for Emacs
# The configuration of these packages are in configuration.org

{ config, pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    custom_emacs = emacsWithPackages (epkgs: (with epkgs.elpaPackages; [
      rainbow-mode             # Displays background colours for names and hex codes.
      which-key                # Displays available keybinding during key chords.
      uniquify-files
    ]) ++ (with epkgs.melpaPackages; [
      diminish                 # Hides minor modes in modelines.
      amx                      # Alternate M-x interface.
      avy                      # Character-wise movement.
      ivy                      # Completion manager.
      counsel                  # Ivy-enhanced commands.
      swiper                   # Ivy-enhanced search.
      general                  # Declarative keybinding. 
      telephone-line           # Modeline
      restart-emacs            # Command to restart Emacs
      dashboard                # Informative splash screen
      all-the-icons            # Text icons
      expand-region            # Select region by syntax units
      elfeed                   # Newsfeeds
      elfeed-org               # Organize newsfeeds with org file.
      elfeed-goodies           # Extra enhancements for Elfeed.
      rainbow-delimiters       # Colour matching brackets togother.  
      nix-mode                 # Mode for editing nix files.
      helpful                  # Enhanced help
      company                  # Auto-completion
      company-quickhelp        # Add information to auto-completion
      yasnippet                # Insert Snippets
      yasnippet-snippets       # Collection of snippets
      flycheck                 # Live linting
      magit                    # Front end for git
      # lua-mode
      org-bullets              # Replace org's asterisks with pretty bullets.
      peep-dired
      dired-subtree
      all-the-icons-dired
      ace-window
      all-the-icons-ivy
      visual-regexp
      ivy-rich
      sly
      clojure-mode
      cider
      geiser
      go-mode
      markdown-mode
      pdf-tools
      nov
      smartparens
      geiser
    ]));
  };

  environment.systemPackages = with pkgs; [
    custom_emacs                        # This package
    emacs-all-the-icons-fonts           # Instead the icons font in the system
    # Spell checkers and related dictionaries.
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    ripgrep                             # Ripgrep, a replacement for the classic grep.
  ];
}
