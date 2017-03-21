{ stdenv, fetchurl, python }:

let
  stateDir = "/tmp/";
in

stdenv.mkDerivation rec {
    name = "${pname}-${version}";
    pname = "neubot";
    version = "0.4.16.9";
    src = fetchurl {
      url = "http://releases.neubot.org/_packages/${name}.tar.gz";
      sha256 = "1djphq80jxwj1r7c2f6c4alnd9jrmqyzdkkp2h102jhnis7af7px";
    };

  patchPhase = ''substituteInPlace Makefile --replace \
    "_install INSTALL" "_install #"'';

  buildInputs = [ python ];

  installPhase = ''
    mkdir $out -p
    mkdir -p "${stateDir}/${pname}"
    make PREFIX="$out/" LOCALSTATEDIR="${stateDir}/${pname}/" install
  '';

    meta = with stdenv.lib; {
      description = "Neubot, the network neutrality bot";
      longDescription = ''Neubot is a research project on network
        neutrality by the Nexa Center for Internet & Society,
        Politecnico di Torino (DAUIN). The project is based on a
        lightweight free software computer program that interested users
        can download and install on their computers. The program runs in
        the background and periodically performs transmission tests with
        servers hosted by the distributed Measurement Lab platform, and,
        in the future, with other instances of Neubot. Transmission
        tests measure network performance with various application-level
        protocols. Test results are saved both locally and on the test
        servers. Data is collected for research purposes and published
        on the web under Creative Commons Zero allowing anyone to re-use
        it freely for the same purpose.
      '';
      maintainers = with maintainers; [ leenaars ];
      platforms = platforms.unix;
      license = licenses.gpl3;
    };
  }
