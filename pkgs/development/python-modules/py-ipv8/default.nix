{ stdenv, buildPythonPackage, fetchFromGitHub, pytest, six, cryptography
, libnacl, netifaces, twisted, pyopenssl }:

buildPythonPackage rec {
  pname = "py-ipv8";
  version = "1.4.764";

  src = fetchFromGitHub {
    owner = "Tribler";
    repo = pname;
    rev = "v1.4";
    sha256 = "00c3862hws9pni187gij8paba0bn1mp1c5imd5dl1h43vs4nr7zg";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ cryptography libnacl netifaces twisted pyopenssl six ];

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ leenaars ];
    description = "Python binding to the Networking and Cryptography (NaCl) library";
    homepage = https://github.com/pyca/pynacl/;
    license = licenses.gpl3;
  };
}
