with import <nixpkgs> {};
with python38Packages;

buildPythonApplication rec {
  pname = "castero";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17h0jx2nw837qx962glsgwhvr6yrs1wnfzlvp0gjy9p7n3mhzci3";
  };

  doCheck = false;

  nativeBuildInputs = [ sqlite ];

  propagatedBuildInputs = [ gevent requests grequests cjkwrap pytz beautifulsoup4 lxml python-vlc mpv ];
}
