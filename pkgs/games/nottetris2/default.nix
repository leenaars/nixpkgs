{ stdenv, fetchurl, unzip, love, lua, makeWrapper, makeDesktopItem }:

let
  pname = "nottetris2";

  icon = fetchurl {
    url = "http://stabyourself.net/images/screenshots/nottetris2-thumb5.png";
    sha256 = "08y3xcd519ikka7308808dyxm6bmh60gm7215c83ymnv33zqsc9r";
  };

  desktopItem = makeDesktopItem {
    name = "nottetris2";
    exec = "${pname}";
    icon = "${icon}";
    comment = "Falling blocks meet real physics interaction";
    desktopName = "Not Tetris 2";
    genericName = "nottetris2";
    categories = "Game;";
  };

in

stdenv.mkDerivation rec {
  name = "${pname}";

  src = fetchurl {
    url = "http://stabyourself.net/dl.php?file=${pname}/${pname}-source.zip";
    sha256 = "13lsacp3bd1xf80yrj7r8dgs15m7kxalqa7vml0k7frmhbkb0b1n";
  };

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ lua love ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip -j $src
  '';  

  installPhase =
  ''
    mkdir -p $out/bin
    mkdir -p $out/share/games/lovegames

    cp -v ./*.love $out/share/games/lovegames/${pname}.love

    makeWrapper ${love}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love

    chmod +x $out/bin/${pname}
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "Falling bricks and messy physics";
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    license = licenses.unfree;
    downloadPage = http://stabyourself.net/nottetris2/;
  };

}
