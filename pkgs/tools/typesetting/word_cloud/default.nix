{ stdenv, fetchFromGitHub, python3Packages, matplotlib }:

python3Packages.buildPythonApplication rec {
  pname = "word_cloud";
  version = "unstable-20180213";

  src = fetchFromGitHub {
    owner = "amueller";
    repo = pname;
    rev = "c435ae2cb0cee29f6ce6d3e6874c682286343ca8";
    sha256= "10rggx1wmvbzpc44sb9j6128kvlkhi824jkzkdfsrp6mirxcjl9c";
  };

  namePrefix = "";

  patchPhase = ''
    substituteInPlace ./wordcloud/wordcloud_cli.py \
      --replace "from . import __version__" "from wordcloud import __version__" 
#      --replace "__version__" "wordcloud.__version__"
  '';

  propagatedBuildInputs = with python3Packages; [ matplotlib numpy pillow ];

  meta = with stdenv.lib; {
    description = "Word cloud generator plus library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.all;
  };
}
