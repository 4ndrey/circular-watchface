import Toybox.Graphics;
import Toybox.WatchUi;

class Label extends WatchUi.Drawable {

    var origin;
    var text;

    var font;
    var color;

    function initialize(params) {
        Drawable.initialize(params);
        color = Graphics.COLOR_BLACK;               
    }

    function draw(dc as Dc) as Void {
        dc.setColor(color, Background.color);
        dc.drawText(
            origin.x,
            origin.y,
            font,
            text,
            Graphics.TEXT_JUSTIFY_LEFT
        );        
    }

}
