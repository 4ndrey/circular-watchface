import Toybox.Math;
import Toybox.System;
import Toybox.Graphics;
import Toybox.Weather;
import Toybox.WatchUi;

class WeatherComplication extends WatchUi.Drawable {

    private var radius;
    private static const toPi = Math.PI / 180;
    private static const penWidth = 4;
    private static const arcRadius = 24;

    var origin;
    var weatherData;

    function initialize(params) {
        Drawable.initialize(params);
        radius = System.getDeviceSettings().screenHeight / 2;
    }    

    function draw(dc as Dc) as Void {
        var weatherInfo = weatherData as WeatherData;
        if (weatherInfo == null) { return; }

        var x = origin.x;
        var y = origin.y + arcRadius / 2;

        // Draw arc
        var start = 180 + 40;
        var end = -40;
        dc.setPenWidth(penWidth);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_WHITE);
        dc.drawArc(x, y, arcRadius, Graphics.ARC_CLOCKWISE, start, end);

        // Add rounding to arc
        var dx = x + Math.cos(start * toPi) * arcRadius;
        var dy = y - Math.sin(start * toPi) * arcRadius;
        dc.fillCircle(dx, dy, penWidth / 2);

        dx = x + Math.cos(end * toPi) * arcRadius;
        dy = y - Math.sin(end * toPi) * arcRadius;
        dc.fillCircle(dx, dy, penWidth / 2);

        // Draw point on arc
        var angle = start + (end - start) * weatherData.ratio();
        dx = x + Math.cos(angle * toPi) * arcRadius;
        dy = y - Math.sin(angle * toPi) * arcRadius;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillCircle(dx, dy, penWidth + 1);
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(dx, dy, penWidth / 2 + 1);

        // Draw current temperature
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE); 
        dc.drawText(x, y - 1, Graphics.FONT_TINY, weatherData.currentTemperature.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

}