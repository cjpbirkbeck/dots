{ pkgs, config, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    st_patched = st.overrideAttrs ( oldAttr: rec {
      src = fetchFromGitHub {
        owner = "cjpbirkbeck";
        repo = "cjpb-st";
        rev = "851b73123f9822d39ff43017bcaca35080080bda";
        sha256 = "1r2vvmiyc4lcw37m1lyh44xhgssv6y4jfcbpfc4d8rxvaxaj4vff";
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
