{ stdenv, fetchFromGitHub, python2Packages, makeWrapper, cmake }:

python2Packages.buildPythonPackage rec {
  pname = "asn2quickder";
  name = "${pname}-${version}";
  version = "1.2-6";

  src = fetchFromGitHub {
    sha256 = "00wifjydgmqw2i5vmr049visc3shjqccgzqynkmmhkjhs86ghzr6";
    rev = "version-${version}";
    owner = "vanrein";
    repo = "quick-der";
  };

  propagatedBuildInputs = with python2Packages; [
    pyparsing makeWrapper cmake asn1ate pip pytestrunner pytest six
    wheel
  ];

  meta = with stdenv.lib; {
    description = "An ASN.1 compiler with a backend for Quick DER";
    homepage = https://github.com/vanrein/asn2quickder;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
