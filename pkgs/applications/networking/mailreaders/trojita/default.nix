{ stdenv, fetchgit, cmake, pkgconfig, qt5, zlib, makeDesktopItem
  #, makeQtWrapper 
  }:

stdenv.mkDerivation rec {
  name = "trojita-0.6";
  src = fetchgit {
    url = "git://anongit.kde.org/trojita.git";
    rev = "17ebc1e25e88912aa84825fbc154dd79c064b420";
    sha256 = "1m4j7n7yj31bgvz2qg685wxcb20ld464px0jdqv0g18bah4pknqm";
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
    cp -R lib $out
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
