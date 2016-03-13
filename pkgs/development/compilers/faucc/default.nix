{ stdenv, fetchurl, autoreconfHook, bison, libtool, flex, xmlto, cppcheck  }:

stdenv.mkDerivation rec {
  name     = "faucc-${version}";
  version  = "20120707";

  src = fetchurl {
    url =
    "http://www3.informatik.uni-erlangen.de/EN/Research/FAUcc/downloads/${name}.tar.gz";
    sha256 = "1p0ggdlkmxr9rhh8ab2wqakq89zda697ppxzjwjr0w8b6qfnwpax";
  };

  patchPhase = ''
    substituteInPlace configure.ac --replace "	docs/man/Makefile" ""
    substituteInPlace Makefile.am --replace "libfaucc \\" "libfaucc"
    substituteInPlace Makefile.am --replace "	docs/man" ""
  '';

  preConfigurePhase = ''
    ./check.sh
  '';

  nativeBuildInputs = [ autoreconfHook bison libtool flex cppcheck xmlto];

  meta = with stdenv.lib; {
    description = "An optimizing C compiler that can generate Intel code for 16bit/32bit CPUs";
    homepage    = http://www3.informatik.uni-erlangen.de/EN/Research/FAUcc/;
    maintainers = with maintainers; [ leenaars ];
    platforms   = attrNames options;
    license     = licenses.gpl2;
  };
}
