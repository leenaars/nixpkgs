{ stdenv, lib, fetchFromGitHub, cmake, qt5, doxygen
, extra-cmake-modules}:

stdenv.mkDerivation rec {
  pname = "atcore";
  version = "unstable-git-20171123";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "${pname}";
    rev = "2ef802eae237f8c5fb9182eaec87014fc6f44410";
    sha256 = "0m2pkpniiwspp79wbri81inhc047436jjvjv8ivl1w727mq078gw";
  };

  buildInputs = [ qt5.qtbase qt5.qtserialport qt5.qtcharts doxygen ];
  propagatedBuildInputs = [ ];
  nativeBuildInputs = [ cmake extra-cmake-modules ];

  cmakeFlags = [ "" ];

  meta = with lib; {
    description = "Print service for 3D printers";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
