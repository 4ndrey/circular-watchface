import Toybox.Graphics;

class Fonts {
    var bigFont;
    var mediumFont;
    var iconsFont;

    function initialize() {
        bigFont = WatchUi.loadResource( Rez.Fonts.BigFont );
        mediumFont = WatchUi.loadResource( Rez.Fonts.MediumFont );
        iconsFont = WatchUi.loadResource( Rez.Fonts.IconsFont );
    }
}