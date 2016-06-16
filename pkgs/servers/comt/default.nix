{ stdenv, pkgs, fetchFromGitHub, pkgconfig, git, python, pandoc, libpqxx, libyaml,
  pythonPackages, buildPythonPackage
  }:

let
  django_1_3 = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.3.7";

    src = pkgs.fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.3/${name}.tar.gz";
      sha256 = "12pv8y2x3fhrcrjayfm6z40r57iwchfi5r19ajs8q8z78i3z8l7f";
    };

    doCheck = false;

    postFixup = ''
      wrapPythonProgramsIn $out/bin "$out $pythonPath"
    '';

    meta = {
      description = "A high-level Python Web framework";
      homepage = https://www.djangoproject.com/;
    };
  };
in

let

  django_tagging = pythonPackages.django_tagging.override { propagatedBuildInputs = [ django_1_3 ]; };

  django_flash = buildPythonPackage rec {
    name = "django-flash-${version}";
    version = "1.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-flash/${name}.tar.gz";
      sha256 = "00icqy4y0h0jqp98rzfg8sc47zinwj9rwnjnm38jdy1bllpn4yrf";
    };

    propagatedBuildInputs = with pythonPackages; [ django_1_3 pysqlite ];

    meta = with stdenv; {
      description = "Django extension which provides support for Rails-like flash messages";
      homepage = https://github.com/danielfm/django-flash;
      stdenv.license = licenses.bsd3;
    };
  };

  django_piston = buildPythonPackage rec {

    name = "django-piston-${version}";
    version = "0.2.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/e6/dc/a634d7fa05c75eed113adbf4f63a75c01371714c30665035abc7e8ca027c/django-piston-0.2.3.tar.gz";
      sha256 = "1scawcwaqpz5gialzn0vpgv3xmkvbnh93szp8m34z4xprqvm20gv";
    };

    propagatedBuildInputs = with pkgs; [ django_1_3 ];

    meta = with stdenv; {
      description = "A Django miniframework creating API's";
      homepage = https://bitbucket.org/jespern/django-piston/wiki/Home;
    };
  };

  django_south = buildPythonPackage rec {

    name = "django-south-${version}";
    version = "1.0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/e3/11/10a986f30ce1a1d5209b192c68adcc3eaf312f9caba70b35c0ac6e354a6b/South-1.0.2.tar.gz";
      sha256 = "1x4jfgpvykqv72dw7qvybsrlbfjv0r8nay5adygzb7cgi4qvsq6k";
    };

    propagatedBuildInputs = with pkgs; [ django_1_3 ];

    meta = with stdenv; {
      description = "Intelligent database migrations for Django";
      homepage = http://south.aeracode.org/;
    };
  };

in

buildPythonPackage rec {
  pname = "comt";
  name = "${pname}-${version}";
  version = "2.6.4";
  src = fetchFromGitHub {
    owner = "co-ment";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bvrz85h5h54v8xl03vxndl5i2zb8bdj49v4526h6f1kzxc76lrh";
  };

  propategedBuildInputs = with pythonPackages; [ pkgconfig git python pandoc libpqxx libyaml
  pythonPackages.magic pythonPackages.magic pythonPackages.pexpect pythonPackages.cssutils
  pythonPackages.memcached pythonPackages.chardet pythonPackages.psycopg2 pythonPackages.simplejson
  pythonPackages.pytz pythonPackages.pytest pythonPackages.html5lib pythonPackages.pillow
  django_1_3 django_tagging pythonPackages.feedparser pythonPackages.tidylib
  django_flash pythonPackages.pysqlite pythonPackages.beautifulsoup
  django_piston django_south
  ];

  meta = {
    description = "A web-based text annotation system";
    homepage    = http://co-ment.org;
    license     = stdenv.lib.licenses.agpl3;
    platforms   = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ leenaars ];
  };
}
