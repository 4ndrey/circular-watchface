import Toybox.ActivityMonitor;
import Toybox.UserProfile;
import Toybox.Time;

class CaloriesProvider {

    private var _goal = Application.Storage.getValue("caloriesGoal");

    hidden function getBmrBasedGoal() {
        var profile = UserProfile.getProfile();
        if (profile.gender == null || profile.weight == null || profile.height == null || profile.birthYear == null) {
            return null;
        }
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var age = today.year - profile.birthYear;
        var bmr = 0;
        if (profile.gender == UserProfile.GENDER_FEMALE) {
            bmr = 655 + 9.6 * profile.weight / 1000.0 + 1.8 * profile.height - 4.7 * age;
        } else {
            bmr = 66.47 + 13.7 * profile.weight / 1000.0 + 5 * profile.height - 6.8 * age;
        }
        var activity = profile.activityClass;
        if (activity == null) {
            activity = 37.5;
        }
        var goal = bmr * (1 + activity / 100.0);
        Application.Storage.setValue("caloriesGoal", goal);
        return goal;
    }

    function getCaloriesBurned() {
        var calories = ActivityMonitor.getInfo().calories;
        if (calories == null) {
            calories = 0;
        }
        return calories;
    }

    function getCaloriesGoal() {
        if (_goal == null || _goal == 0) {
            _goal = getBmrBasedGoal();
        }
        if (_goal == null) {
            return 0;
        }
        return _goal;
    }
}