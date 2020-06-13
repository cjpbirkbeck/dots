{ pkgs, config, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    st_patched = st.overrideAttrs ( oldAttr: rec {
      src = fetchFromGitHub {
        owner = "cjpbirkbeck";
        repo = "st";
        rev = "a530240fb14fd342babc17ee483cdbd9d96bd800";
        sha256 = "16yrjq8b7zcj8dmkdik1qkcvhwbylzp53vki6j7vkz3gfjzmcg3x";
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
