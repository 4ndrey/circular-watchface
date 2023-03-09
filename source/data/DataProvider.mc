import Toybox.ActivityMonitor;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Time;

class DataProvider {

    private var _bodyBattery = 0;

    function getSegments() {
        var activityInfo = ActivityMonitor.getInfo();

        var stepsSegment = new Segment(ACTIVITY_TYPE_STEPS, normalize(activityInfo.steps, activityInfo.stepGoal));
        var floorsSegment = new Segment(ACTIVITY_TYPE_FLOORS, normalize(activityInfo.floorsClimbed, activityInfo.floorsClimbedGoal));
        var activeMinutesSegment = new Segment(ACTIVITY_TYPE_ACTIVE_MINUTES, normalize(activityInfo.activeMinutesWeek.total, activityInfo.activeMinutesWeekGoal));
        var energySegment = new Segment(ACTIVITY_TYPE_ENERGY, normalize(getBodyBattery(), 100));

        var segments = [];

        segments.add(stepsSegment);
        if (activeMinutesSegment.isValid) { segments.add(activeMinutesSegment); }
        else { segments.add(floorsSegment); }
        segments.add(energySegment);

        return segments;
    }

    function getBodyBattery() {
        var bbIterator = getIterator();
        if (bbIterator == null) { return _bodyBattery; }
        var sample = bbIterator.next();
        _bodyBattery = (sample != null && sample.data > 0) ? sample.data : _bodyBattery;        
        return _bodyBattery;
    }

    function getHour() {
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        return hours.format("%02d").toString();
    }

    function getMinute() {
        var clockTime = System.getClockTime();
        var minutes = clockTime.min;
        return minutes.format("%02d").toString();
    }

    function getDate() {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        return today.day_of_week + " " + today.day.toString();
    }

    function hasNotifications() {
        return System.getDeviceSettings().notificationCount > 0;
    }

    function getWeatherData() {
        var weatherData = new WeatherData();        
        var weather = Weather.getCurrentConditions();
        if (weather != null) {
            weatherData.currentTemperature = weather.temperature;
            weatherData.minTemperature = weather.lowTemperature;
            weatherData.maxTemperature = weather.highTemperature;
            weatherData.upcomingWeatherCondition = weather.condition;
            // Get weather condition for the next hour
            var forecasts = Weather.getHourlyForecast();
            if (forecasts != null && forecasts.size() > 0) {
                weatherData.upcomingWeatherCondition = forecasts[1].condition;
            }
        }
        return weatherData.isValid() ? weatherData : null;
    }

    hidden function normalize(current, goal) {
        if (current == null || goal == null || goal == 0) { return 0; }
        var ratio = current.toFloat() / goal;
        return ratio > 1 ? 1.0 : ratio;
    }

    // Create a method to get the SensorHistoryIterator object
    hidden function getIterator() {
        // Check device for SensorHistory compatibility
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)) {
            // Set up the method with parameters
            return Toybox.SensorHistory.getBodyBatteryHistory({:period => 1});
        }
        return null;
    }    
}