import Toybox.Graphics;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {

    static const color = Graphics.COLOR_WHITE;

    function initialize() {
        Drawable.initialize({});
    }    

    function draw(dc as Dc) as Void {
        // Set the background color then call to clear the screen
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
    }

}
