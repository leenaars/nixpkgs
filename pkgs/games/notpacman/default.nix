{ stdenv, fetchurl, unzip, love, lua, makeWrapper, makeDesktopItem }:

let
  pname = "notpacman";

  icon = fetchurl {
    url = "http://stabyourself.net/images/screenshots/notpacman-4.png";
    sha256 = "1cx95a0pfymnwcid0yjc46s1lnlyn0yc6r7k3a62iqg3yipaqapf";
  };

  desktopItem = makeDesktopItem {
    name = "notpacman";
    exec = "${pname}";
    icon = "${icon}";
    comment = "Maze game with physics interaction";
    desktopName = "Not Pacman";
    genericName = "notpacman";
    categories = "Game;";
  };

in

stdenv.mkDerivation rec {
  name = "${pname}";

  src = fetchurl {
    url = "http://stabyourself.net/dl.php?file=${pname}/${pname}-source.zip";
    sha256 = "1z7jgqm5kixadxf60x2z52v8szwihhyan4jh9aawhsbxffq3phcy";
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
    description = "Mashup game where you are in charge of a maze with well-known video game characters";
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    license = licenses.nonfree;
    downloadPage = http://stabyourself.net/notpacman/;
  };

}
