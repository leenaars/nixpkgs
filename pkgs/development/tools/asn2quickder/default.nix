{ stdenv, fetchFromGitHub, python2Packages, makeWrapper, cmake }:

python2Packages.buildPythonPackage rec {
  pname = "asn2quickder";
  name = "${pname}-${version}";
  version = "1.2-3";

  src = fetchFromGitHub {
    sha256 = "0p7mx15wzs41nz0saq8qbxm7cl0nw8alp60dr7ig915p93sd5y5q";
#    rev = "version-${version}";
    rev = "1fcc3caf05c40ec275fafd1a4ac2584e13cc6d5e";
    owner = "vanrein";
    repo = "quick-der";
  };

  propagatedBuildInputs = with python2Packages; [
    pyparsing makeWrapper cmake asn1ate pip pytestrunner pytest six
    wheel
  ];

#  sourceRoot = "source/python";

#  patchPhase = with python2Packages; ''
#    substituteInPlace Makefile \
#      --replace '..' '..:$(DESTDIR)/${python.sitePackages}:${python2Packages.pyparsing}/${python.sitePackages}' \
#    '';
#
#  installPhase = ''
#    mkdir -p $out/${python2Packages.python.sitePackages}/
#    mkdir -p $out/bin $out/lib
#    PYTHONPATH=$out/${python2Packages.python.sitePackages}/:$PYTHONPATH
#    cd ../..
#    #python setup.py sdist bdist_wheel 
#    #python setup.py -v install --root=$out 
#    #PYTHONUSERBASE=$out pip install --user ./ -d $out
#    PYTHONUSERBASE=$out pip wheel --wheel-dir=$out
#    '';
#
  meta = with stdenv.lib; {
    description = "An ASN.1 compiler with a backend for Quick DER";
    homepage = https://github.com/vanrein/asn2quickder;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
