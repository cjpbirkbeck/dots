{ pkgs, config, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    st_patched = st.overrideAttrs ( oldAttr: rec {
      src = fetchFromGitHub {
        owner = "cjpbirkbeck";
        repo = "st";
        rev = "00e2d40de643f3f9cf0d8c8a9ff06cae70d4312e";
        sha256 = "11qsa8gij67skdpvgzy84ayavikkn2mym2gw4zbjdrmsr7jfz52h";
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
