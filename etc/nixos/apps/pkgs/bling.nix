with import <nixpkgs> {};
with luaPackages;

stdenv.mkDerivation rec {
  name = "bling";

  src = fetchFromGitHub {
    owner = "BlingCorp";
    repo = "bling";
    rev = "3fc80c7dfd9da54361dedb47f03ec3638e4f5581";
    sha256 = "0a5dsn179wcb76wdklny6jryyfj3llh1v1wfnwjq3dv0a8bn6ls6";
  };

  buildInputs = [ lua ];

  preBuild = ''
    sed -i -E 's_\.\.\._\(\.\.\.\)_g' init.lua
  '';

  installPhase = ''
      mkdir -p $out/lib/lua/${lua.luaversion}/
      cp -r . $out/lib/lua/${lua.luaversion}/bling/
      printf "package.path = '$out/lib/lua/${lua.luaversion}/?/init.lua;' ..  package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${lua.luaversion}/bling.lua
  '';
}
