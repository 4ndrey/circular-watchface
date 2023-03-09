import Toybox.Graphics;
import Toybox.Math;

class Segment {
    var activityType;
    var value;
    var isValid;

    (:debug)
    function initialize(_activityType, _value) {
        activityType = _activityType;
        value = 0.35;//Math.rand() % 100 / 100.0;
        isValid = value > 0.1;
    }

    (:release)
    function initialize(_activityType, _value) {
        activityType = _activityType;
        value = _value < 0.01 ? 0.01 : _value;
        isValid = _value > 0.1;
    }

    function color() {
        switch (activityType) {
            case ACTIVITY_TYPE_STEPS:
                return Graphics.COLOR_RED; //0xd81b60;
            case ACTIVITY_TYPE_FLOORS:
                return Graphics.COLOR_DK_GREEN; //0x388e3c;
            case ACTIVITY_TYPE_ACTIVE_MINUTES:
                return Graphics.COLOR_DK_GREEN;//0x388e3c;
            case ACTIVITY_TYPE_ENERGY:
                return Graphics.COLOR_PURPLE;
            default:
                return Graphics.COLOR_TRANSPARENT;
        }
    }

    function inactiveColor() {
        switch (activityType) {
            case ACTIVITY_TYPE_STEPS:
                return 0x2b0513;
            case ACTIVITY_TYPE_FLOORS:
                return 0x4a411c;
            case ACTIVITY_TYPE_ACTIVE_MINUTES:
                return 0x4a411c;
            case ACTIVITY_TYPE_ENERGY:
                return 0x1a243f;
            default:
                return Graphics.COLOR_TRANSPARENT;
        }
    }

    function icon() {
        switch (activityType) {
            case ACTIVITY_TYPE_STEPS:
                return "s";
            case ACTIVITY_TYPE_FLOORS:
                return "F";
            case ACTIVITY_TYPE_ACTIVE_MINUTES:
                return "c";
            case ACTIVITY_TYPE_ENERGY:
                return "t";
            default:
                return "?";
        }
    }
}