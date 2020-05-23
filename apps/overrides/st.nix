{ pkgs, config, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    st_patched = st.overrideAttrs ( oldAttr: rec {
      src = fetchFromGitHub {
        owner = "cjpbirkbeck";
        repo = "st";
        rev = "a6be7ed01a89e467261f5ac1fb4ce70d877dc66b";
        sha256 = "1z8nfficjirsbc7z3ckd4z9806lcawadgs0znypz5gpd6p15lcw0";
      };

      buildInputs = with pkgs.xorg; [ libX11 libXft libXcursor ];

      installPhase = ''
        TERMINFO=$out/share/terminfo make install PREFIX=$out

        mkdir -p $out/share/applications/
        install -D st.desktop $out/share/applications/
      '';
    } );
  };

  environment.systemPackages = with pkgs; [ st_patched ];
}
