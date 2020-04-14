{ pkgs, config, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    st_patched = st.overrideAttrs ( oldAttr: rec {
      src = fetchFromGitHub {
        owner = "cjpbirkbeck";
        repo = "cjpb-st";
        rev = "101d7dfb1090a3495580397d20536b35af33f986";
        sha256 = "047dd9z7mxp2ialcf8xwfagw37k3927aamhj0y6k3yjqbjwx5gws";
      };

      postInstall = ''
        TERMINFO=$out/share/terminfo make install PREFIX=$out -Dt $out/share/applications st.desktop
      '';
    } );
  };

  environment.systemPackages = with pkgs; [ st_patched ];
}
