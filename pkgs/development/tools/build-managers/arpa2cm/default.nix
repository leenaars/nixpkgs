{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "arpa2cm";
  version = "1.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    sha256 = "00k1zwh3mpc1yg804cy9j7s68z750hg73h2vbsbyw5hd2kqlkyq7";
    rev = "aac243358de3792362ba5470c849331ef695219d";
    repo = "${pname}";
    owner = "arpa2";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "CMake Module library for the ARPA2 project";
    license = licenses.bsd2;
    maintainers = with maintainers; [ leenaars ];
  };
}
