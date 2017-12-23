{ stdenv, fetchgit, apacheHttpd, apr, aprutil, pkgconfig
, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "mod_ca";
  version = "0.2";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://source.redwax.eu/scm/rs/${pname}.git";
    sha256 = "1q3z2kwr3lkk9hi3q17ljbqjadbrvkmc3caqllj08xrdcbfpddcw";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ apacheHttpd pkgconfig ];
  propagatedBuildInputs = [ apr aprutil ];

  configureFlags = ["--with-apxs=${apacheHttpd.dev}/bin/apxs"];

  installPhase = ''
    mkdir -p $out/modules $out/share
    cp ./.libs/mod_* $out/modules
    cp ./*.h $out/share
  '';

  meta = {
    homepage = "https://redwax.eu/rs/";
    description = "Module that integrates backend and frontend of Redwax server";
    platforms = stdenv.lib.platforms.linux;
  };

}
