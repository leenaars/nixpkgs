{ stdenv, fetchgit, apacheHttpd, pkgconfig, mod_ca, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "mod_crl";
  version = "0.2";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://source.redwax.eu/scm/rs/${pname}.git";
    sha256 = "088k7qazg18b89ny9h6vvksmb321h4s6qc3s9dwisfffrra9r5vj";
  };

  patchPhase = ''
   ln -s ${mod_ca}/share/mod_ca.h ./
   '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ apacheHttpd pkgconfig mod_ca ];

  installPhase = ''
    mkdir -p $out/modules
    cp ./.libs/mod_* $out/modules
  '';

  meta = {
    homepage = "https://redwax.eu/rs/";
    description = "Apache module that exposes an RFC5280 Certificate Revocation List";
    platforms = stdenv.lib.platforms.linux;
  };

}
