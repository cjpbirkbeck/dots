{ config, pkgs, ... }:

let
  
in
{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    latest_vimpc = vimpc.overrideAttrs ( oldAttr: rec {
      src = fetchFromGitHub {
        owner = "boysetsfrog";
        repo = "vimpc";
        rev = "c5186105a9932ffdb1710810eff3019be3c2a805";
        sha256 = "1inma2lp8r89fax8ipji3mv9pkzipds72krqm73f1l5drn6qpmr3";
      };
    });
  };
}
