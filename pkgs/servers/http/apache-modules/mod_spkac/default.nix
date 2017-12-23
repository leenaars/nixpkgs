{ stdenv, fetchgit, apacheHttpd, pkgconfig, mod_ca, autoreconfHook}:

stdenv.mkDerivation rec {
  pname = "mod_spkac";
  version = "0.2";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://source.redwax.eu/scm/rs/${pname}.git";
    sha256 = "165ih8bgfi546n2qfsg58zh92sd5zrbais50bqwdkq40dvq819xc";
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
    description = "Apache module serving certificates through Signed Public Key and Challenge";
    platforms = stdenv.lib.platforms.linux;
  };

}
