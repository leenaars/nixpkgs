{ stdenv, fetchPypi, buildPythonPackage, vlc }:

buildPythonPackage rec {
  pname = "python-vlc";
  version = "1.1.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0788h5qcq6pqdd6l2z5aznxfcfshga8myddz2wdc5gsi02fq29wp";
  };

  propagatedBuildInputs = [ vlc ];

  # Seems to require a browser
  #doCheck = false;

  meta = {
    description = "Provides ctypes-based bindings for the native libvlc API of VLC video player";
    homepage    = "http://wiki.videolan.org/PythonBinding";
    license     = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ leenaars ];
  };
}
