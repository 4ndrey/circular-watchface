import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;

class NotificationsView extends WatchUi.Drawable {

    var origin;
    var isVisible;

    function initialize(params) {
        Drawable.initialize(params);
    }

    function draw(dc as Dc) as Void {
        if (!isVisible) { return; }

        dc.setColor(Colors.foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            origin.x,
            origin.y,
            Fonts.iconsFont, 
            "n",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );        
    }

}
