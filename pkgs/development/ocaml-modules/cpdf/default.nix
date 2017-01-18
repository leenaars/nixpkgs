{ stdenv, fetchFromGitHub, ocaml, findlib, camlpdf, ncurses }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.0";

let version = "2.2"; in

stdenv.mkDerivation {
  name = "ocaml-cpdf-${version}";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "cpdf-source";
    rev = "v${version}";
    sha256 = "0kh80hs5swryxnwd1vl4w83i4p3rd3yy43hqsvwr49djhfx3haqh";
  };

  buildInputs = [ ocaml findlib ncurses ];
  propagatedBuildInputs = [ camlpdf ];

  createFindlibDestdir = true;

  postInstall = ''
    mkdir -p $out/bin
    cp cpdf $out/bin
    mkdir -p $out/share/
    cp -r doc $out/share
    cp cpdfmanual.pdf $out/share/doc/cpdf/
  '';

  meta = {
    homepage = http://www.coherentpdf.com/;
    platforms = ocaml.meta.platforms or [];
    description = "PDF Command Line Tools";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
