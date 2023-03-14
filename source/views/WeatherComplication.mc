import Toybox.Math;
import Toybox.System;
import Toybox.Graphics;
import Toybox.Weather;
import Toybox.WatchUi;

class WeatherComplication extends WatchUi.Drawable {

    private var radius;
    private static const toPi = Math.PI / 180;
    private static const penWidth = 8;
    private static var arcRadius = 0;

    var origin;
    var weatherData;

    function initialize(params) {
        Drawable.initialize(params);
        radius = System.getDeviceSettings().screenHeight / 2;
        arcRadius = System.getDeviceSettings().screenHeight / 8;
    }    

    function draw(dc as Dc) as Void {
        var weatherInfo = weatherData as WeatherData;
        if (weatherInfo == null) { return; }

        var x = origin.x;
        var y = origin.y;

        var start = new Point(x - 30, y);
        var end = new Point(x + 30, y);
        var value = start.x + (end.x - start.x) * weatherData.ratio();

        // Draw arc
        dc.setPenWidth(penWidth + 1);
        dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_WHITE);
        dc.drawLine(
            start.x, start.y - 1,
            value, start.y - 1
        );

        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_WHITE);
        dc.drawLine(
            value, start.y - 1,
            end.x, end.y - 1
        );

        // Add rounding to line
        dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_WHITE);
        dc.fillCircle(start.x - 3, start.y - 1, penWidth / 2);
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_WHITE);
        dc.fillCircle(end.x + 2, end.y - 1, penWidth / 2);        

        // Draw point on arc
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillCircle(value, y - 1, penWidth);
        var color = Graphics.COLOR_BLACK;
        var weatherType = weatherData.weatherType();
        if (weatherType == WEATHER_TYPE_SHOWER_RAIN ||
            weatherType == WEATHER_TYPE_RAIN ||
            weatherType == WEATHER_TYPE_THUNDER) {
            color = Graphics.COLOR_BLUE;
        }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(value, y - 1, penWidth / 2 + 1);

        // Draw current temperature
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT); 
        dc.drawText(x, y + 18, Graphics.FONT_TINY, weatherData.currentTemperature.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw min and max temperature
        dc.drawText(start.x - 15, y - 1, Graphics.FONT_XTINY, weatherData.minTemperature.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(end.x + 18, y - 1, Graphics.FONT_XTINY, weatherData.maxTemperature.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

}