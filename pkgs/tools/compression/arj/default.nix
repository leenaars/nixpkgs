{ stdenv, fetchurl, autoreconfHook, libtool }:

stdenv.mkDerivation rec {
  version = "3.10.22";
  name    = "arj-${version}";

  src = fetchurl {
    url    = "http://arj.sourceforge.net/files/${name}.tar.gz";
    sha256 = "1nx7jqxwqkihhdmdbahhzqhjqshzw1jcsvwddmxrwrn8rjdlr7jq";
  };

  patches = [
    ./arj-3.10.22-arches_align.patch
    ./arj-3.10.22-no_remove_static_const.patch
    ./arj-3.10.22-64_bit_clean.patch
    ./arj-3.10.22-parallel_build.patch
    ./arj-3.10.22-use_safe_strcpy.patch
    ./arj-3.10.22-doc_refer_robert_k_jung.patch
    ./arj-3.10.22-security_format.patch
    ./arj-3.10.22-missing-protos.patch
    ./arj-3.10.22-custom-printf.patch
    ./arj-3.10.22-quotes.patch
    ./arj-3.10.22-security-afl.patch
    ./arj-3.10.22-security-traversal-dir.patch
    ./arj-3.10.22-security-traversal-symlink.patch
  ];

  buildInputs = [ libtool autoreconfHook ];

  preConfigure = ''
  substituteInPlace gnu/config.guess --replace "ld --help" "ld.bfg --help"
  cd gnu 
  echo `pwd`
  rm makefile
  mv gnu/* ./ 
  '';

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
