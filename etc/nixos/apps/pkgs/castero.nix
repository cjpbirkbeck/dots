with import <nixpkgs> {};
with python38Packages;

buildPythonApplication rec {
  pname = "castero";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vnVN2YpbDoWhKbnkJY3AtPIsyXby2mbxXpun2KUJzAk=";
  };

  doCheck = false;

  nativeBuildInputs = [ sqlite ];

  propagatedBuildInputs = [ gevent requests grequests cjkwrap pytz beautifulsoup4 lxml python-vlc mpv ];
}
