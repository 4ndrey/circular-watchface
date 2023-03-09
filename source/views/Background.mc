import Toybox.Graphics;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {

    function draw(dc as Dc) as Void {
        // Set the background color then call to clear the screen
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
    }

}
