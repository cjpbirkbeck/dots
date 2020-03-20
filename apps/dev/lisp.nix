# Installs programming environments for various LISPs.

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Common Lisp
    sbcl
    asdf # Build system for Common Lisp

    # Clojure
    clojure
    leiningen # Build system

    # Scheme
    chez
  ];
}
