import Toybox.Graphics;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {

    function initialize() {
        Drawable.initialize({});
    }    

    function draw(dc as Dc) as Void {
        // Set the background color then call to clear the screen
        dc.setColor(Colors.backgroundColor, Colors.backgroundColor);
        dc.clear();
    }

}
