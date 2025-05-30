{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  makeWrapper,
  jre,
}:

let
  gradle = gradle_8;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stirling-pdf";
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "Stirling-Tools";
    repo = "Stirling-PDF";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Cl2IbFfw6TH904Y63YQnXS/mDEuUB6AdCoRT4G+W0hU=";
  };

  patches = [
    # remove timestamp from the header of a generated .properties file
    ./remove-props-file-timestamp.patch
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  # disable spotless because it tries to fetch files not in deps.json
  # and also because it slows down the build process
  gradleFlags = [
    "-x"
    "spotlessApply"
  ];

  doCheck = true;

  nativeBuildInputs = [
    gradle
    gradle.jdk # one of the tests also require that the `java` command is available on the command line
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/Stirling-PDF-*.jar $out/share/stirling-pdf/Stirling-PDF.jar
    makeWrapper ${jre}/bin/java $out/bin/Stirling-PDF \
        --add-flags "-jar $out/share/stirling-pdf/Stirling-PDF.jar"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v${finalAttrs.version}";
    description = "Locally hosted web application that allows you to perform various operations on PDF files";
    homepage = "https://github.com/Stirling-Tools/Stirling-PDF";
    license = lib.licenses.gpl3Only;
    mainProgram = "Stirling-PDF";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = jre.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
  };
})
