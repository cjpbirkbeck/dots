{ pkgs, config, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    st_patched = st.overrideAttrs ( oldAttr: rec {
      src = fetchFromGitHub {
        owner = "cjpbirkbeck";
        repo = "st";
        rev = "851f7df4da3dcb1ec91f419cf7ac252f6659ff3c";
        sha256 = "0iqyd666q2vh41ra820l3cxq72py1wxmjr1ix7swzarn5ph8zmj5";
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

  # environment.systemPackages = with pkgs; [ st_patched ];
}
