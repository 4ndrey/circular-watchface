import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;

class Fonts {
    static var bigFont;
    static var mediumFont;
    static var smallFont;
    static var iconsFont;

    static function load() {
        if (bigFont == null) {
            bigFont = System.getDeviceSettings().screenHeight > 400 ? 
                Graphics.FONT_SYSTEM_NUMBER_THAI_HOT : WatchUi.loadResource( Rez.Fonts.BigFont );

            mediumFont = System.getDeviceSettings().screenHeight > 400 ?
                Graphics.FONT_SYSTEM_NUMBER_MEDIUM : WatchUi.loadResource( Rez.Fonts.MediumFont );

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