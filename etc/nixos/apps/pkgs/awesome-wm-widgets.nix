with import <nixpkgs> {};
with luaPackages;

stdenv.mkDerivation rec {
  name = "awesome-wm-widgets";

  src = fetchFromGitHub {
    owner = "streetturtle";
    repo = "awesome-wm-widgets";
    rev = "3b24474de4646519634b842edbc539d49c55abbb";
    sha256 = "1ms6k0gwc3v44njn8fkmml24vnd62pkw6l7m3psg4zyj06xcm3rb";
  };

  buildInputs = [ lua ];

  installPhase = ''
      mkdir -p $out/lib/lua/${lua.luaversion}/
      cp -r . $out/lib/lua/${lua.luaversion}/awesome-wm-widgets/
      printf "package.path = '$out/lib/lua/${lua.luaversion}/?/init.lua;' ..  package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${lua.luaversion}/awesome-wm-widgets.lua
  '';
}
