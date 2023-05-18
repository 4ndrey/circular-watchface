import Toybox.Graphics;
import Toybox.WatchUi;

class Label extends WatchUi.Drawable {

    var origin;
    var text;
    var font;

    function initialize(params) {
        Drawable.initialize(params);
    }

    function draw(dc as Dc) as Void {
        dc.setColor(Colors.foregroundColor, Colors.backgroundColor);
        dc.drawText(
            origin.x,
            origin.y,
            font,
            text,
            Graphics.TEXT_JUSTIFY_LEFT
        );        
    }

}
