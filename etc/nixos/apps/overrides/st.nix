{ pkgs, config, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    st_patched = st.overrideAttrs ( oldAttr: rec {
      src = fetchFromGitHub {
        owner = "cjpbirkbeck";
        repo = "st";
        rev = "70696f382e10e0e47a62eb174f59f204353d34b1";
        sha256 = "07sdylckpzvxg1blina6xvcwiaq6h9wb3h8vcdbwyscn3kcicp5j";
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
