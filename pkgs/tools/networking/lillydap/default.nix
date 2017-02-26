{stdenv, fetchFromGitHub, quickder, cmake }:

stdenv.mkDerivation rec {
  pname = "lillydap";
  version = "0.4-beta2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "vanrein";
    repo = "lillydap";
    rev = "version-${version}";
    sha256 = "1aga9570cyrjhmvwm7hqzd40dvkhis60wgw6hfw848kvmkrgpvg3";
  };

  buildInputs = [ quickder cmake ];

  meta = {
    description = "Little LDAP: Event-driven, lock-free kernel for dynamic data servers, clients, filters, ...";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
