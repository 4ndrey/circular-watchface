import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;

class BatteryView extends WatchUi.Drawable {

    var origin;
    var isVisible;

    function initialize(params) {
        Drawable.initialize(params);
    }

    function draw(dc as Dc) as Void {
        if (!isVisible) { return; }

        var batteryLevel = System.getSystemStats().battery;
        var s = "";
        if (System.getSystemStats().charging) {
            s = "l";
        } else if (batteryLevel > 50 ) {
            s = "h";
        } else if (batteryLevel > 20) {
            s = "m";
        } else {
            s = "k";
        }

        var color = batteryLevel <= 10 ? Graphics.COLOR_DK_RED : Colors.foregroundColorAlt;
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            origin.x,
            origin.y,
            Fonts.iconsFont, 
            s,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );        
    }

}
