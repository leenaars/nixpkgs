{ stdenv, fetchgit, cmake, pkgconfig, qt5, zlib, makeDesktopItem
  #, makeQtWrapper 
  }:

stdenv.mkDerivation rec {
  name = "trojita-0.6";
  src = fetchgit {
    url = "git://anongit.kde.org/trojita.git";
    rev = "8c1206a93257143c056404aaec6ec69f06e1ef6c";
    sha256 = "17f776adajhzi4x7018wvggd6ygpkpdl714ql16bmm3bymsl6xhg";
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

  nativebuildInputs = [ cmake pkgconfig 
  #makeQtWrapper 
  ];
  buildInputs = [ cmake pkgconfig qt5.qtbase qt5.qtwebkit zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp trojita $out/bin
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
