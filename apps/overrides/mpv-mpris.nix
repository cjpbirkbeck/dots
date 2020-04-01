{ config, stdenv, fetchFromGitHub, lua, ... }:

let

in stdenv.mkDerivation rec {
  pname = "mpv-mpris";
  version = "0.2";
  src = fetchFromGitHub {
    owner = "";
    repo = "";
    rev = "";
    sha256 = "";
  };
}
