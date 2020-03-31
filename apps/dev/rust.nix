{ pkgs, config, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      rustc
      cargo
    ];

    variables = {
      CARGO_HOME = "$HOME/.local/share/cargo";
    };
  };
}

