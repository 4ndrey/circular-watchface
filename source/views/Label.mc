import Toybox.Graphics;
import Toybox.WatchUi;

class Label extends WatchUi.Drawable {

    var origin;
    var text;
    var font;
    var alignment = Graphics.TEXT_JUSTIFY_LEFT;

    function initialize(params) {
        Drawable.initialize(params);
    }

    function draw(dc as Dc) as Void {
        dc.setColor(Colors.foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            origin.x,
            origin.y,
            font,
            text,
            alignment
        );        
    }

}
