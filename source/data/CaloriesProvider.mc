import Toybox.Application;
import Toybox.ActivityMonitor;
import Toybox.UserProfile;
import Toybox.Time;
import Toybox.System;

class CaloriesProvider {
    private static var _baseKcal = 0;
    private static var _goal = Application.Properties.getValue("ActiveCaloriesGoal");

    hidden function getBaseKcal() {
        if (_baseKcal == 0) {
            var profile = UserProfile.getProfile();
            if (profile.gender == null || profile.weight == null || profile.height == null || profile.birthYear == null) {
                return 0;
            }
            var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            var age = today.year - profile.birthYear;

            // Mifflin-St.Jeor Formula (1990)
            var baseKcal = 0;
            if (profile.gender == UserProfile.GENDER_FEMALE) {
                baseKcal = (9.99 * profile.weight / 1000.0) + (6.25 * profile.height) - (4.92 * age) - 161.0;           // base kcal woman        
            } else {
                baseKcal = (9.99 * profile.weight / 1000.0) + (6.25 * profile.height) - (4.92 * age) + 5.0;             // base kcal men
            }
            baseKcal += (baseKcal * 0.21385);
            _baseKcal = baseKcal;            
        }
        return _baseKcal;
    }

    function getCaloriesBurned() {
        var calories = ActivityMonitor.getInfo().calories;
        if (calories == null) {
            calories = 0;
        }
        return calories;
    }

    function getActiveCalories() {
        var kcalPerMinute = getBaseKcal() / 1440; // base kcal per minute
        var clockTime = System.getClockTime();
        var activeKcal = (getCaloriesBurned() - (kcalPerMinute * (clockTime.hour * 60.0 + clockTime.min))).toNumber();
        return activeKcal < 0 ? 0 : activeKcal;
    }

    function getCaloriesGoal() {
        return _goal;
    }
}