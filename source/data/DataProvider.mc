import Toybox.ActivityMonitor;
import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Time;

class DataProvider {

    private var _bodyBattery = 0;
    private var _heartRate = 0;

    private var _caloriesProvider = new CaloriesProvider();

    function getSegments() {
        var activityInfo = ActivityMonitor.getInfo();
        
        var segments = [];

        // Steps
        var stepsSegment = new Segment(ACTIVITY_TYPE_STEPS, normalize(activityInfo.steps, activityInfo.stepGoal));
        segments.add(stepsSegment);

        // Floors
        if (Application.Properties.getValue("FloorsSegment")) {
            var floorsSegment = new Segment(ACTIVITY_TYPE_FLOORS, normalize(activityInfo.floorsClimbed, activityInfo.floorsClimbedGoal));
            segments.add(floorsSegment);
        }

        // Active Minutes
        if (Application.Properties.getValue("ActiveMinutesSegment")) {
            var activeMinutesSegment = new Segment(ACTIVITY_TYPE_ACTIVE_MINUTES, normalize(activityInfo.activeMinutesWeek.total, activityInfo.activeMinutesWeekGoal));
            segments.add(activeMinutesSegment);
        }

        // Calories
        if (Application.Properties.getValue("CaloriesSegment")) {
            var caloriesSegment = new Segment(ACTIVITY_TYPE_CALORIES, normalize(_caloriesProvider.getCaloriesBurned(), _caloriesProvider.getCaloriesGoal()));
            segments.add(caloriesSegment);
        }

        // Body Battery
        var energySegment = new Segment(ACTIVITY_TYPE_ENERGY, normalize(getBodyBattery(), 100));
        segments.add(energySegment);

        // Device Battery
        if (Application.Properties.getValue("BatteryIndicator")) {
            var batterySegment = new Segment(ACTIVITY_TYPE_BATTERY, normalize(System.getSystemStats().battery, 100));
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
        var value = Activity.getActivityInfo().currentHeartRate;
        if (value != null) {
            return value;
        }
        var interator = getHeartRateIterator();
        if (interator == null) { return _heartRate; }
        var sample = interator.next();
        _heartRate = (sample != null && sample.data > 0) ? sample.data : _heartRate;        
        return _heartRate;
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
        var dateFormat = Application.Properties.getValue("DateFormat");
        var result = stringReplace(dateFormat, "d", today.day_of_week);
        result = stringReplace(result, "D", today.day.toString());
        result = stringReplace(result, "M", today.month.toString());
        return result;
    }

    function notificationsCount() {
        return System.getDeviceSettings().notificationCount;
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

    hidden function normalize(current, goal) {
        if (current == null || goal == null || goal == 0) { return 0; }
        var ratio = current.toFloat() / goal;
        return ratio > 1 ? 1.0 : ratio;
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