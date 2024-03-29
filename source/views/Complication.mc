import Toybox.Math;
import Toybox.System;
import Toybox.Graphics;
import Toybox.Weather;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.UserProfile;

class Complication extends WatchUi.Drawable {

    private static const unit = "°";
    private var penWidth = 8;

    var origin;
    var weatherData;
    var heartRateData;

    var needsUpdate = false;

    var _zones;
    var _hrColors = {
        0 => Graphics.COLOR_DK_GRAY,
        1 => Graphics.COLOR_BLUE,
        2 => Graphics.COLOR_GREEN,
        3 => Graphics.COLOR_ORANGE,
        4 => Graphics.COLOR_DK_RED
    };

    function initialize(params) {
        Drawable.initialize(params);
    
        _zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
    }    

    function draw(dc as Dc) as Void {
        var notes = Application.Properties.getValue("Notes");
        if (notes != null && notes.length() > 0) {
            drawNotes(dc, notes);
        } else {
            var zones = _zones as Array<Number>;
            if (heartRateData != null && zones != null 
                && (heartRateData >= zones[1] || Application.Properties.getValue("DynamicComplication") == 2 /* HR only*/)) {
                drawHeartRate(dc);
            } else {
                drawWeather(dc);
            }
        }
    }

    hidden function drawHeartRate(dc as Dc) {
        if (heartRateData == null) { return; }

        var x = origin.x;
        var y = origin.y;

        var barHalfWidth = dc.getWidth() / 5;
        var start = new Point(x - barHalfWidth, y);
        var end = new Point(x + barHalfWidth, y);
        var step = (end.x - start.x) / 5;

        // Draw line
        dc.setPenWidth(penWidth + 1);
        for (var i = 0; i < 5; i++) {
            dc.setColor(_hrColors.get(i), Colors.backgroundColor);
            dc.drawLine(
                start.x + step * i, start.y - 1,
                start.x + step * (i + 1) - (i == 4 ? penWidth : 0), start.y - 1
            );
        }

        // Add rounding to line
        dc.fillCircle(end.x - 6, end.y - 1, penWidth / 2);        
        dc.setColor(_hrColors.get(0), Colors.backgroundColor);
        dc.fillCircle(start.x - 3, start.y - 1, penWidth / 2);

        // Draw point on line
        var value = start.x + (end.x - start.x) * hrRatio();
        dc.setColor(Colors.backgroundColor, Colors.backgroundColor);
        dc.fillCircle(value, y - 1, penWidth);
        dc.setColor(Colors.foregroundColor, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(value, y - 1, penWidth / 2 + 1);

        // Draw current HR rate
        dc.setColor(Colors.foregroundColor, Graphics.COLOR_TRANSPARENT); 
        dc.drawText(x + 10, y + 19, Graphics.FONT_TINY, heartRateData.format("%.0f"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        // Icon
        dc.drawText(
            x - 15,
            y + 19,
            Fonts.iconsFont, 
            "p",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        ); 

        needsUpdate = true;
    }

    hidden function hrRatio() {
        var zones = _zones as Array<Number>;
        if (zones.size() == 0) {
            return 0;
        }
        var ratio = (heartRateData - zones[0]) * 1.0 / (zones[5] - zones[0]);
        ratio = ratio < 0 ? 0 : ratio;
        ratio = ratio > 1 ? 1.0 : ratio;
        return ratio;
    }    

    hidden function drawWeather(dc as Dc) {
        var weatherInfo = weatherData as WeatherData;
        if (weatherInfo == null || weatherInfo.forecasts.size() == 0) { return; }

        var x = origin.x;
        var y = origin.y;

        var barHalfWidth = Math.round(dc.getWidth() / 5.65);
        var start = new Point(x - barHalfWidth - 2, y);
        var end = new Point(x + barHalfWidth - 2, y);
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
        dc.drawText(x, y + dc.getHeight() / 11, Graphics.FONT_TINY, weatherData.currentTemperature.format("%.0f") + unit, 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );        

        // Draw min and max temperature
        dc.setColor(Colors.foregroundColorAlt, Graphics.COLOR_TRANSPARENT);
        dc.drawText(start.x - 12, y - 2, Graphics.FONT_XTINY, weatherData.minTemperature.format("%.0f"), 
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(end.x + 12, y - 2, Graphics.FONT_XTINY, weatherData.maxTemperature.format("%.0f"), 
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );

        needsUpdate = false;
    }

    hidden function drawNotes(dc as Dc, notes as String) {
        dc.setColor(Colors.foregroundColor, Graphics.COLOR_TRANSPARENT); 
        dc.drawText(origin.x, origin.y, Graphics.FONT_SYSTEM_TINY, notes, 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        ); 
    }

}