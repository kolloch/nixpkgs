{ stdenv, fetchurl, cmake, pkgconfig, SDL2, SDL2_image, SDL2_mixer, SDL2_net, SDL2_ttf
, pango, gettext, boost, libvorbis, fribidi, dbus, libpng, pcre, openssl, icu
, Cocoa, Foundation
, enableTools ? false
}:

stdenv.mkDerivation rec {
  pname = "wesnoth";
  version = "1.14.10";

  src = fetchurl {
    url = "mirror://sourceforge/sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0xnfbz7nin56ms929i5f8rv4mpifbvr64r4ryfhrqmba0vkk9sz7";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ SDL2 SDL2_image SDL2_mixer SDL2_net SDL2_ttf pango gettext boost
                  libvorbis fribidi dbus libpng pcre openssl icu ]
                ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa Foundation];

  cmakeFlags = [ "-DENABLE_TOOLS=${if enableTools then "ON" else "OFF"}" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
    longDescription = ''
      The Battle for Wesnoth is a Free, turn-based tactical strategy
      game with a high fantasy theme, featuring both single-player, and
      online/hotseat multiplayer combat. Fight a desperate battle to
      reclaim the throne of Wesnoth, or take hand in any number of other
      adventures.
    '';

    homepage = http://www.wesnoth.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
