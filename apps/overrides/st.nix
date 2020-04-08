{ pkgs, config, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    st_patched = st.overrideAttrs ( oldAttr: rec {
      src = fetchFromGitHub {
        owner = "cjpbirkbeck";
        repo = "cjpb-st";
        rev = "c945c9fb4da3929203542ba3c156819241a89d35";
        sha256 = "0s9h7qjqnsjn12synygakflsi491scp8mr5kw8a90v0h90aicccy";
      };

      postInstall = ''
        TERMINFO=$out/share/terminfo make install PREFIX=$out -Dt $out/share/applications st.desktop
      '';
    } );
  };

  environment.systemPackages = with pkgs; [ st_patched ];
}
