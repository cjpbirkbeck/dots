{ pkgs, config, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    st_patched = st.overrideAttrs ( oldAttr: rec {
      src = fetchFromGitHub {
        owner = "cjpbirkbeck";
        repo = "cjpb-st";
        rev = "0d759a069fcb115e86ad0285ae86010c0e6ae482";
        sha256 = "0d5nh9qb3015rnpmk4484jakdph7p40jw3fhqhhyl4mndm8xiqc0";
      };

      postInstall = ''
        TERMINFO=$out/share/terminfo make install PREFIX=$out -Dt $out/share/applications st.desktop
      '';
    } );
  };

  environment.systemPackages = with pkgs; [ st_patched ];
}
