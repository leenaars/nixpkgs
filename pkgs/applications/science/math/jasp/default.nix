{ stdenv, fetchFromGitHub, R, boost, libarchive, zlib, pkgconfig
, qt5, qt4, qmake4Hook
}:


stdenv.mkDerivation rec {
  pname = "jasp";
  version = "0.8.0.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "jasp-stats";
    repo = "jasp-desktop";
    rev = "v${version}";
    sha256 = "0s1wgq0k2ldn1p60in1k6yrbjp9x89h9jfil0xgsnw945xcl3g4d";
  };

  buildInputs = [ R boost libarchive zlib qt5.webkit ]
    ++ { qt4 = [ qt4 ]; qt5 = [ qt5.qtbase ]; }."qt5"
    # ++ { qt4 = [ qt4 ]; qt5 = [ qt5.qtbase ]; }."qt ## $ ## {toString source.qtVersion}"
    # ++ (overrides.buildInputs or [ ]);
    ++ [ ];

    nativeBuildInputs = [ pkgconfig ]
      ++ { qt4 = [ qmake4Hook ]; qt5 = [ qt5.qmakeHook ]; }."qt5";
      # ++ { qt4 = [ qmake4Hook ]; qt5 = [ qt5.qmakeHook ]; }."qt${toString source.qtVersion}"

    qmakeFlags = [
      "CONFIG+=shared"
      "CONFIG+=no-g15"
      "CONFIG+=packaged"
      "CONFIG+=no-update"
      "CONFIG+=no-embed-qt-translations"
    ];

    preConfigure = ''
       qmakeFlags="$qmakeFlags DEFINES+=PLUGIN_PATH=$out/lib"
    '';

  meta = with stdenv.lib; {
    license     = licenses.agpl3;
    description = "Complete statistical package for Bayesian and Frequentist methods";
    longDescription = ''

      This program computes the discovery and exclusion limits that can be set
      in prospective studies of new experiments in the search for new
      phenomena. It properly takes into account the different outcomes that the
      experiment can obtain including the possible signal and background
      fluctuations. The procedure gives in general more conservative limits than
      those obtained assuming that the experiment will obtain a number of events
      equal to the expected mean. The difference may be essential in those cases
      where only one experiment is foreseen to be carried out.

    '';
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.all;
  };

}
