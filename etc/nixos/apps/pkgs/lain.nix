with import <nixpkgs> {};
with luaPackages;

stdenv.mkDerivation rec {
  name = "lain";

  src = fetchFromGitHub {
    owner = "lcpz";
    repo = "lain";
    rev = "1db09ba186b076abb34f60e92761bd612b4dc851";
    sha256 = "12h1abr4xjr322by87sxrwqfpmyawziaxgk1lzicx0z6ywy0ch05";
  };

  buildInputs = [ lua ];

  installPhase = ''
      mkdir -p $out/lib/lua/${lua.luaversion}/
      cp -r . $out/lib/lua/${lua.luaversion}/lain/
      printf "package.path = '$out/lib/lua/${lua.luaversion}/?/init.lua;' ..  package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${lua.luaversion}/lain.lua
  '';
}
