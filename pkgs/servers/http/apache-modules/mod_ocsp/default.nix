{ stdenv, fetchgit, apacheHttpd, pkgconfig, apr, aprutil, mod_ca
, autoreconfHook}:

stdenv.mkDerivation rec {
  pname = "mod_ocsp";
  version = "0.2";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://source.redwax.eu/scm/rs/${pname}.git";
    sha256 = "0qvnzpawg3782kw7q4ibi93azbgzsccz5jc7cspccqlbfqvg2kqa";
  };

  patchPhase = ''
   ln -s ${mod_ca}/share/mod_ca.h ./
   '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ apacheHttpd pkgconfig apr aprutil mod_ca ];

  installPhase = ''
    mkdir -p $out/modules 
    cp ./.libs/mod_* $out/modules
  '';


  meta = {
    homepage = "https://redwax.eu/rs/";
    description = "Apache module creating an RFC6960 OCSP request endpoint";
    platforms = stdenv.lib.platforms.linux;
  };

}
