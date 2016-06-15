{ stdenv, fetchurl, autoreconfHook, libtool, gettext }:

stdenv.mkDerivation rec {
  version = "3.10.22";
  name    = "arj-${version}";

  src = fetchurl {
    url    = "http://arj.sourceforge.net/files/${name}.tar.gz";
    sha256 = "1nx7jqxwqkihhdmdbahhzqhjqshzw1jcsvwddmxrwrn8rjdlr7jq";
  };

  buildInputs = [ autoreconfHook libtool gettext ];

  # Config for building with gcc (rather than nmake) in ./gnu
  patchPhase = "cd gnu && mv configure.in configure.ac";

  configureScript = "./gnu/configure";

  meta = {
    homepage    = http://arj.sourceforge.net/;
    description = "Re-implementation of the ARJ archiver";
    longDescription =
      ''
      Open-source implementation of the ARJ archiver, created with an 
      intent to preserve maximum compatibility and retain the feature set 
      of the original ARJ archiver as provided by ARJ Software, Inc.
      '';
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ leenaars ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
