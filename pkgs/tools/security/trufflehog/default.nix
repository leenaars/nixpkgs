{ stdenv, pythonPackages, fetchFromGitHub, makeWrapper, pkgs }:

let 
  GitPython = pythonPackages.buildPythonPackage rec {
    version = "2.1.1";
    name = "GitPython-${version}";
    src = pkgs.fetchurl {
      url = "mirror://pypi/G/GitPython/GitPython-${version}.tar.gz";
      sha256 = "0132r4pr86iixy0h06ilnrh8fclifmk8giczb6ky1zpr7jaqwvz9";
    };
    buildInputs = with pythonPackages; [ mock nose ];
    propagatedBuildInputs = with pythonPackages; [ gitdb ];
    doCheck = false;
  };
  gitdb = pythonPackages.buildPythonPackage rec {
    pname = "gitdb";
    version = "2.0.3";
    name = "${pname}-${version}";
    src = pkgs.fetchFromGitHub {
      owner = "gitpython-developers";
      repo = "${pname}";
      rev = "${version}";
      sha256 = "0m54qs0hx9rv3kgddnqqziz0l7b9dqpdq11pmxfd1cnnhfmnw8m2";
    };
    buildInputs = with pythonPackages; [ nose ];
    propagatedBuildInputs = with pythonPackages; [ smmap2 ];
    doCheck = false;
  };
  smmap2 = pythonPackages.buildPythonPackage rec {
    pname = "smmap2";
    version = "2.0.3";
    name = "${pname}-${version}";
    src = pkgs.fetchFromGitHub {
      owner = "gitpython-developers";
      repo = "smmap";
      rev = "v${version}";
      sha256 = "14n8w6qnxbhhl4fb5ig125g20nqvprlpi9035vm9jmsivcv5kdx5";
    };
    buildInputs = with pythonPackages; [ nose nosexcover ];
    doCheck = false;
  };

in

pythonPackages.buildPythonApplication rec {
  pname = "trufflehog";
  version = "unstable-20170929";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "dxa4481";
    repo = "${pname}";
    rev = "d04d3b7571f13c4df2b89ee5b8514a472a566cd0";
    sha256 = "0zaiq3hmnmi178dr1m54zv9hn65xklhkikfkybcb0vn4valljw56";
  };

  propagatedBuildInputs = [ pythonPackages.GitPython ];

  doCheck = true;

  postInstall = let
    mapPath = f: x: stdenv.lib.concatStringsSep ":" (map f x);
  in ''
  wrapProgram $out/bin/${pname} \
    --prefix PATH : "${mapPath (x: "${x}/bin") propagatedBuildInputs}" \
  '';

  meta = with stdenv.lib; {
    description = "Searches for high entropy strings";
    longDescription = ''
      A tool to searches through git repositories for high entropy strings
      (such as password, API keys, etcetera), digging deep into commit
      history.
    '';
    maintainers = with maintainers; [ leenaars ];
  };
}
