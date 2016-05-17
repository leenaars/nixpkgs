{ stdenv, fetchgit, cmake, pkgconfig, qt5, zlib, makeDesktopItem, gpgme, mimetic
  }:

stdenv.mkDerivation rec {
  name = "trojita-0.6";
  src = fetchgit {
    url = "git://anongit.kde.org/trojita.git";
    rev = "6b72a7d5f52bd21df58e247a03c21f66438caaf0";
    sha256 = "0ilfabryam61pms7qfrmrky6cfayk63zf6l3lmsawhrzysjy6r11";
  };

  desktopItem = makeDesktopItem {
    name = "trojita";
    exec = "trojita";
    icon = "trojita";
    desktopName = "Trojita";
    genericName = "Trojita";
    comment = meta.description;
    categories = "Office;Email;";
  };

  nativebuildInputs = [ cmake pkgconfig ];
  buildInputs = [ cmake pkgconfig qt5.qtbase qt5.qtwebkit zlib gpgme
  mimetic];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp trojita $out/bin
    cp -R lib* $out/lib
#    wrapQtProgram $out/bin/trojita

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications

  '';

  meta = with stdenv.lib;{
    description = "Fast IMAP client";
    homepage = http://trojita.flaska.net;
    maintainers = with stdenv.lib.maintainers; [ leenaars ];
  };
}
