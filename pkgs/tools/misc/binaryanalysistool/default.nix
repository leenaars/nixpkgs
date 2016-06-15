{                 stdenv
,                 fetchsvn
,                 pythonPackages
,                 bsdiff
,                 bzip2
,                 cabextract
,                 clamav
,                 coreutils
,                 cpio
,                 ctags
,                 e2fsprogs
,                 e2tools
,                 eot_utilities
,                 file
,                 fuse
,                 fuseiso
,                 gd
,                 gettext
,                 giflib
,                 gzip
,                 icoutils
,                 john
,                 jre
,                 liberation_ttf
,                 libxml2
,                 lrzip
,                 lzip
,                 lzma
,                 lzop
,                 ncompress
,                 netpbm
,                 openssl
,                 p7zip
,                 poppler_utils
,                 rpm
,                 squashfsTools
,                 gnutar
,                 ucl
,                 unrar
,                 unshield
,                 unzip
,                 upx
,                 vorbis-tools
,                 xz
,                 zip
,                 mtdutils
#                 arj
} :

pythonPackages.buildPythonApplication rec {
  pname = "bat";
  version = "26.0";
  name = "${pname}-${version}";

#  src = ../../../../../binaryanalysis/src/. ;

  src = fetchsvn {
    url = "https://tjaldur.nl:8443/repos/gpltool/trunk";
    rev = "5201";
    sha256 = "abb8e42830632f0e38feee76dab0ddae237ed259e1ffc45465620aae3e0cbaad";
  };

  propagatedBuildInputs = [ pythonPackages.magic
                  pythonPackages.pillow
                  pythonPackages.psycopg2
                  pythonPackages.pydot
                  pythonPackages.reportlab
                  pythonPackages.matplotlib
                  pythonPackages.fonttools
                  pythonPackages.sqlite3

                  # bat-extratools >= 23.0
                  # bat-extratools-java >= 23.0

                  bsdiff
                  bzip2
                  cabextract
                  clamav
                  coreutils
                  cpio
                  ctags
                  e2fsprogs
                  e2tools
                  file
                  fuse
                  fuseiso
                  gd # actually only gd-progs
                  gettext
                  giflib # actually only giflib-utils
                  gzip
                  icoutils
                  john
                  jre # java
                  liberation_ttf
                  libxml2
                  lrzip
                  lzip
                  lzma # originally listed as xz-lzma-compat
                  lzop
                  ncompress
                  netpbm # actually only netpbm-progs
                  openssl
                  p7zip # includes plugins? p7zip-plugins
                  poppler_utils
                  rpm
                  squashfsTools
                  gnutar
                  ucl
                  unrar
                  unshield
                  unzip
                  upx
                  vorbis-tools
                  xz
                  zip
                  mtdutils
                  eot_utilities
#                 arj
#                 rpm-python
		  ];
  doCheck = false;
  sourceRoot = "./src";

  patchPhase = ''
    substituteInPlace setup.py \
      --replace /etc/bat $out/etc/bat
    patchShebangs ./
  '';

  installPhase = ''
   mkdir -p $out/etc/bat/configs $out/share/doc/
   mkdir -p $out/bin $out/share/doc/
   python setup.py install --prefix=$out
   #python src/setup.py install --prefix=$out --docPath $out/share/doc
   '';

  meta = {
    homepage = http://binaryanalysis.org;
    description = "Tool to analyse binaries";
    license = stdenv.lib.licenses.apsl20;
    maintainers = with stdenv.lib.maintainers; [ leenaars ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
