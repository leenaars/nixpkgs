{ stdenv, fetchgit, autoconf, automake, libtool, pkgconfig, gnumake } :

stdenv.mkDerivation rec {

  name = "jsonccc";
  version = "json-c-0.12-20140410";

  buildInputs = [ autoconf automake libtool pkgconfig gnumake ];

  src = fetchgit {
    url = "https://github.com/json-c/json-c";
    rev = "refs/tags/${version}";
    sha256 = "0s9h6147v2vkd4l4k3prg850n0k1mcbhwhbr09dzq97m6vi9lfdi";
  };
}