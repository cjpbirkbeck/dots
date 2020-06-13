# Setting for working with Go language programming.

{ config, pkgs, ... }:

{
  environment = {
    variables = {
      GOPATH = "$HOME/Code/go:$HOME/go";
      # GOBIN = "$HOME/.local/bin";
    };

    systemPackages = with pkgs; [
      go
    ];
  };
}
