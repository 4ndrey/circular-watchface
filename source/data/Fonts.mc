import Toybox.Graphics;
import Toybox.WatchUi;

class Fonts {
    static var bigFont;
    static var mediumFont;
    static var smallFont;
    static var iconsFont;

    static function load() {
        if (bigFont == null) {
            bigFont = WatchUi.loadResource( Rez.Fonts.BigFont );
            mediumFont = WatchUi.loadResource( Rez.Fonts.MediumFont );
            smallFont = Graphics.FONT_SYSTEM_TINY;
            iconsFont = WatchUi.loadResource( Rez.Fonts.IconsFont );
        }
    }

    static function unload() {
        bigFont = null;
        mediumFont = null;
        smallFont = null;
        iconsFont = null;
    }
}