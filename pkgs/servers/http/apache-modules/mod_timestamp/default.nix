{ stdenv, fetchgit, apacheHttpd, pkgconfig, mod_ca, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "mod_timestamp";
  version = "0.2";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://source.redwax.eu/scm/rs/${pname}.git";
    sha256 = "124pi0zzn9iwx2c42b4wxv6riglxk6radax2lp5dk212mhm3z1bi";
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
    description = "Apache module exposing RFC3161 Time Stamp Protocol document timestamping";
    platforms = stdenv.lib.platforms.linux;
  };

}
