{ pkgs, config, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    st_patched = st.overrideAttrs ( oldAttr: rec {
      src = fetchFromGitHub {
        owner = "cjpbirkbeck";
        repo = "st";
        rev = "eebfc2792bcefafbb2d5e9759ddef5620f47d57b";
        sha256 = "1v3ivkx2ygn8jkfw8gd94bpvlqkli8zsf796ihd6q0zvnnwnia6m";
      };

      buildInputs = with pkgs.xorg; [ libX11 libXft libXcursor ];

      preBuild = ''
        sed -i -e '/share\/applications/d' Makefile
      '';

      installPhase = ''
        TERMINFO=$out/share/terminfo make install PREFIX=$out

        mkdir -p $out/share/applications/
        install -D st.desktop $out/share/applications/
      '';
    } );
  };
}
