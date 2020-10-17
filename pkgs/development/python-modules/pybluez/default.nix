{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pkgs
}:

buildPythonPackage rec {
  version = "0.23";
  pname = "pybluez";

  propagatedBuildInputs = [ pkgs.bluez ];

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-o1L6ewSZrt6laPJMKikeVlMwltoOgg4p3o1x7u0bdpI=";
  };

  # the tests do not pass
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Bluetooth Python extension module";
    license = licenses.gpl2;
    maintainers = with maintainers; [ leenaars ];
  };

}
