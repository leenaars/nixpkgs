{ stdenv, fetchgit, apacheHttpd, pkgconfig, mod_ca, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "mod_scep";
  version = "0.2";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://source.redwax.eu/scm/rs/${pname}.git";
    sha256 = "1rv7by1609mz4s8rbar7kaxz73ljf15sqg0x8gww6wzf8bkfq29f";
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
    description = "Apache module exposing IETF Draft Simple Certificate Enrollment Protocol endpoint";
    platforms = stdenv.lib.platforms.linux;
  };

}
