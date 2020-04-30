{ stdenv, fetchgit, lvm2, libgcrypt, libuuid, pkgconfig, popt
, gettext, autoconf, automake, libtool
, enablePython ? true, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-1.6.8";

  # https://www.saout.de/pipermail/dm-crypt/2016-April/005171.html
  preConfigure = ''
    ./autogen.sh
  '';

  src = fetchgit {
    url = "https://gitlab.com/cryptsetup/cryptsetup.git";
    rev = "v1_6_8";
    sha256 = "1lr9sz3hryhvb792sx8wc76jz0r5lqdgs2kls40ssbmv2zjfzm97";
  };

  patches = [
    ./cryptsetup.patch
  ];

  configureFlags = [ "--enable-cryptsetup-reencrypt" ]
                ++ stdenv.lib.optional enablePython "--enable-python";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lvm2 libgcrypt libuuid popt gettext autoconf automake libtool ]
             ++ stdenv.lib.optional enablePython python;

  meta = {
    homepage = "http://code.google.com/p/cryptsetup/";
    description = "LUKS for dm-crypt";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
