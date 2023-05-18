import Toybox.Math;
import Toybox.System;
import Toybox.Graphics;
import Toybox.Weather;
import Toybox.WatchUi;
import Toybox.Lang;

class WeatherComplication extends WatchUi.Drawable {

    private var radius;
    private static const unit = "°";
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
        if (weatherInfo == null || weatherInfo.forecasts.size() == 0) { return; }

        var x = origin.x;
        var y = origin.y;

        var start = new Point(x - 35, y);
        var end = new Point(x + 35, y);
        var step = (end.x - start.x) / weatherData.forecasts.size();

        var forecasts = weatherData.forecasts as Array<Forecast>;

        // Draw line
        dc.setPenWidth(penWidth + 1);
        for (var i = 0; i < forecasts.size(); i++) {
            var forecast = forecasts[i];
            dc.setColor(forecast.color, Colors.backgroundColor);
            dc.drawLine(
                start.x + step * i, start.y - 1,
                start.x + step * (i + 1), start.y - 1
            );            
        }

        // Add rounding to line
        dc.fillCircle(end.x + 2, end.y - 1, penWidth / 2);        
        dc.setColor(forecasts[0].color, Colors.backgroundColor);
        dc.fillCircle(start.x - 3, start.y - 1, penWidth / 2);

        // Draw current temperature
        dc.setColor(Colors.foregroundColor, Graphics.COLOR_TRANSPARENT); 
        dc.drawText(x, y + 19, Graphics.FONT_TINY, weatherData.currentTemperature.toString() + unit, 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );        

        // Draw current and max temperature
        dc.setColor(Colors.foregroundColorAlt, Colors.backgroundColor); 
        dc.drawText(start.x - 12, y - 2, Graphics.FONT_XTINY, weatherData.minTemperature.toString(), 
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(end.x + 12, y - 2, Graphics.FONT_XTINY, weatherData.maxTemperature.toString(), 
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

}