{ stdenv, fetchFromGitHub, pythonPackages, makeWrapper, }:

stdenv.mkDerivation rec {
  pname = "mu-editor";
  name = "${pname}-${version}";
  version = "unstable-20170307";
  revision = "6a8744d";

  src = fetchFromGitHub {
    owner = pname;
    repo = "mu";
    rev = revision;
    sha256 = "26mk76qgg7fgca11yvpygicxqbkc0kn6r82x73fly2310pagd845";
    fetchSubmodules = true;
  };

  buildInputs = [
    pythonPackages.python
    pythonPackages.wrapPython
    makeWrapper
  ];

  pythonPath = [
    pythonPackages.pyqt5
  ];

#  installPhase = ''
#    mkdir -pv $out
#    # Nasty hack; call wrapPythonPrograms to set program_PYTHONPATH.
#    wrapPythonPrograms
#    cp -prvd ./* $out/
#    makeWrapper ${pythonPackages.python}/bin/python $out/bin/mu \
#        --set PYTHONPATH $out:$program_PYTHONPATH 
#        }
#  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ xvapx ];
    description = "A completely decentralised P2P filesharing client based on the Bittorrent protocol";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
