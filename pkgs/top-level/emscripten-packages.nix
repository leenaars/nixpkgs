# This file defines the composition for emscripten packages.

{pkgs, overrides}:

let self = _self // overrides; _self = with self; {

   inherit (pkgs) emscripten buildEmscriptenPackage emscriptenStdenv fetchurl fetchFromGitHub callPackage;
#   inherit (stdenv.lib) maintainers;

  # works
  jsonc = callPackage ../development/jasonccc.nix {
    stdenv = emscriptenStdenv;
  };
  
  # failz
  json_c = pkgs.json_c.override {
    stdenv = emscriptenStdenv;
  };
  
  # failz
  libxml2 = pkgs.libxml2.override {
    stdenv = emscriptenStdenv;
  };
  
  # works
  libz = buildEmscriptenPackage {
    name="libz";

    buildInputs = [ emscripten ];

    configurePhase = ''
      # fake conftest results with emscripten's python magic
      export EMCONFIGURE_JS=2

      # Some tests require writing at $HOME
      HOME=$TMPDIR

      emconfigure ./configure --prefix=$out
    '';
    
    src = pkgs.fetchurl {
      url = "http://zlib.net/zlib-1.2.8.tar.gz";
      sha256 = "039agw5rqvqny92cpkrfn243x2gd4xn13hs3xi6isk55d2vqqr9n";
    };
  };

}; in self
