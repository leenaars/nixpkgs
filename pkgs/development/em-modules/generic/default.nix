{ pkgs, parallel, lib, emscripten }:

{ buildInputs ? [], nativeBuildInputs ? [], passthru ? {}, preFixup ? ""

# We want parallel builds by default
, enableParallelBuilding ? true

# Disabled flag
, disabled ? false

# Extra sources to include in the gopath
, extraSrcs ? [ ]

, dontRenameImports ? false

, meta ? {}, ... } @ args:

pkgs.stdenv.mkDerivation (
  args // 
  {

  name = "emscripten-${args.name}";
  nativeBuildInputs = [ emscripten parallel ]
    ++ nativeBuildInputs;
  buildInputs = [ emscripten ] ++ buildInputs;

  configurePhase = args.configurePhase or ''
    # fake conftest results with emscripten's python magic
    export EMCONFIGURE_JS=2

    # Some tests require writing at $HOME
    HOME=$TMPDIR
    runHook preConfigure

    ./autogen.sh
    emconfigure ./configure --prefix=$out

    runHook postConfigure
  '';

  buildPhase = args.buildPhase or ''
    runHook preBuild
    export EMCONFIGURE_JS=2

    # Some tests require writing at $HOME
    HOME=$TMPDIR
    emmake make

    runHook postBuild
  '';

  preFixup = args.preFixup or "";

  checkPhase = args.checkPhase or ''
    runHook preCheck

    runHook postCheck
  '';

installPhase = args.installPhase or ''
    runHook preInstall

    mkdir -p $out
    make install

    runHook postInstall
  '';

  meta = {
    # Add default meta information
    platforms = lib.platforms.all;
  } // meta // {
    # add an extra maintainer to every package
    maintainers = (meta.maintainers or []) ++
                  [ lib.maintainers.qknight ];
  };
})
