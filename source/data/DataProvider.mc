import Toybox.ActivityMonitor;
import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Time;

class DataProvider {

    private var _bodyBattery = 0;

    private var _caloriesProvider = new CaloriesProvider();

    function getSegments() {
        var activityInfo = ActivityMonitor.getInfo();
        
        var segments = [];

        // Steps
        var stepsSegment = new Segment(ACTIVITY_TYPE_STEPS, activityInfo.steps, activityInfo.stepGoal, null);
        segments.add(stepsSegment);

        // Floors
        if (Application.Properties.getValue("FloorsSegment")) {
            var floorsSegment = new Segment(ACTIVITY_TYPE_FLOORS, activityInfo.floorsClimbed, activityInfo.floorsClimbedGoal, null);
            segments.add(floorsSegment);
        }

        // Active Minutes
        if (Application.Properties.getValue("ActiveMinutesSegment")) {
            var activeMinutesSegment = new Segment(ACTIVITY_TYPE_ACTIVE_MINUTES, activityInfo.activeMinutesWeek.total, activityInfo.activeMinutesWeekGoal, null);
            segments.add(activeMinutesSegment);
        }

        // Calories
        if (Application.Properties.getValue("CaloriesSegment")) {
            var caloriesSegment = new Segment(ACTIVITY_TYPE_CALORIES, _caloriesProvider.getActiveCalories(), _caloriesProvider.getCaloriesGoal(), null);
            segments.add(caloriesSegment);
        }

        // Body Battery
        if (Toybox.SensorHistory has :getBodyBatteryHistory) {
            var energySegment = new Segment(ACTIVITY_TYPE_ENERGY, getBodyBattery(), 100, null);
            segments.add(energySegment);
        }

        // Device Battery
        if (Application.Properties.getValue("BatteryIndicator")) {
            var batteryLabel = "";
            if (Toybox.System.Stats has :batteryInDays) {
                batteryLabel = System.getSystemStats().batteryInDays.format("%.0f") + "d";
            } else {
                batteryLabel = System.getSystemStats().battery.format("%.0f");
            }
            var batterySegment = new Segment(ACTIVITY_TYPE_BATTERY, 
                System.getSystemStats().battery, 100, 
                batteryLabel
            );
            segments.add(batterySegment);
        }

        return segments;
    }

    function getBodyBattery() {
        var bbIterator = getBodyBatteryIterator();
        if (bbIterator == null) { return _bodyBattery; }
        var sample = bbIterator.next();
        _bodyBattery = (sample != null && sample.data > 0) ? sample.data : _bodyBattery;        
        return _bodyBattery;
    }

    function getHeartRate() {
        if (Application.Properties.getValue("DynamicComplication") == 1 /* weather only*/) {
            return null;
        }
        var info = Activity.getActivityInfo();
        if (info != null) {
            var value = info.currentHeartRate;
            if (value != null) {
                return value;
            }
        }
        var interator = getHeartRateIterator();
        if (interator == null) { return null; }
        var sample = interator.next();
        return sample != null ? sample.data : null;
    }    

    function getHour() {
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        return hours;
    }

    function getMinutes() {
        var clockTime = System.getClockTime();
        var minutes = clockTime.min;
        return minutes.format("%02d").toString();
    }

    function getSeconds() {
        var clockTime = System.getClockTime();
        var seconds = clockTime.sec;
        return seconds;
    }    

    function getDate() {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);        
        var dateMapping = {
            "d" => today.day_of_week,
            "D" => today.day.toString(),
            "M" => today.month.toString()
        };        
        var dateFormat = Application.Properties.getValue("DateFormat");
        var chars = dateFormat.toCharArray();
        var result = "";
        for (var i = 0; i < chars.size(); i++) {
            var char = chars[i].toString();
            var s = dateMapping.get(char);
            if (s != null) {
                result += s;
            } else {
                result += char;
            }
        }
        return result;
    }

    function notificationsCount() {
        if (!System.getDeviceSettings().phoneConnected) {
            return null;
        } else {
            return System.getDeviceSettings().notificationCount;
        }
    }

    function getWeatherData() {
        if (Application.Properties.getValue("DynamicComplication") == 2 /* HR only*/) {
            return null;
        }
        if (self has :Weather) {
            var weatherData = new WeatherData();        
            var weather = Weather.getCurrentConditions();
            if (weather != null) {
                weatherData.currentTemperature = weather.temperature;
                weatherData.minTemperature = weather.lowTemperature;
                weatherData.maxTemperature = weather.highTemperature;
                weatherData.upcomingWeatherCondition = weather.condition;

                var forecasts = Weather.getHourlyForecast();
                if (forecasts != null && forecasts.size() > 0) {
                    var max = forecasts.size() > 10 ? 10 : forecasts.size();
                    var dt = (weather.highTemperature - weather.lowTemperature) / 4;
                    var color;
                    for (var i = 0; i < max; i++) {
                        if (forecasts[i].precipitationChance >= 40) {
                            color = Graphics.COLOR_DK_BLUE;
                        } else {
                            var t = forecasts[i].temperature - weather.lowTemperature;
                            if (t <= dt) {
                                color = Graphics.COLOR_BLUE;
                            } else if (t <= 3 * dt) {
                                color = Graphics.COLOR_YELLOW;
                            } else {
                                color = Graphics.COLOR_ORANGE;
                            }
                        }

                        var forecast = new Forecast(color, forecasts[i].forecastTime);
                        weatherData.forecasts.add(forecast);
                    }
                }
            }
            return weatherData.isValid() ? weatherData : null;
        } else {
            return null;
        }
    }

    // Create a method to get the SensorHistoryIterator object
    hidden function getBodyBatteryIterator() {
        // Check device for SensorHistory compatibility
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)) {
            // Set up the method with parameters
            return Toybox.SensorHistory.getBodyBatteryHistory({:period => 1});
        }
        return null;
    }

    hidden function getHeartRateIterator() {
        // Check device for SensorHistory compatibility
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getHeartRateHistory)) {
            // Set up the method with parameters
            return Toybox.SensorHistory.getHeartRateHistory({:period => 1});
        }
        return null;
    }
    
}