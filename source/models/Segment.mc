import Toybox.Graphics;
import Toybox.Math;

class Segment {
    var activityType;
    var value;
    var label;
    var isValid;

    (:debug)
    function initialize(_activityType, _value, goal, specialLabel) {
        activityType = _activityType;
        value = Math.rand() % 100 / 100.0;
        label = getLabel(_value, value, specialLabel);
        isValid = value >= 0.01;
    }

    (:release)
    function initialize(_activityType, _value, goal, specialLabel) {
        activityType = _activityType;
        var ratio = normalize(_value, goal);
        value = ratio < 0.01 ? 0.01 : ratio;
        isValid = ratio >= 0.01;
        label = getLabel(_value, ratio, specialLabel);
    }

    function color() {
        switch (activityType) {
            case ACTIVITY_TYPE_STEPS:
                return Graphics.COLOR_RED; //0xd81b60;
            case ACTIVITY_TYPE_FLOORS:
                return Graphics.COLOR_YELLOW; //0x388e3c;
            case ACTIVITY_TYPE_ACTIVE_MINUTES:
                return Graphics.COLOR_ORANGE; //0x388e3c;
            case ACTIVITY_TYPE_ENERGY:
                return Graphics.COLOR_PURPLE;
            case ACTIVITY_TYPE_CALORIES:
                return Graphics.COLOR_DK_GREEN;
            case ACTIVITY_TYPE_BATTERY:
                return Graphics.COLOR_DK_BLUE;
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
                return "t";
            case ACTIVITY_TYPE_ENERGY:
                return "y";
            case ACTIVITY_TYPE_BATTERY:
                return "m";
            case ACTIVITY_TYPE_CALORIES:
                return "c";
            default:
                return "?";
        }
    }

    hidden function normalize(current, goal) {
        if (current == null || goal == null || goal == 0) { return 0; }
        var ratio = current.toFloat() / goal;
        return ratio;
    }    

    hidden function getLabel(value, ratio, special) {
        var kind = Application.Properties.getValue("SegmentsLabels");
        if (kind == 2) {
            return null;
        } else if (kind == 0 && ratio >= 2) {
            return "x" + ratio.format("%.0f");
        } else if (kind == 1 && ratio > 0.12) {
            if (special != null) {
                return special;
            } else if (value >= 1000) {
                return (value / 1000).format("%.0f") + "k";
            } else {
                return value.format("%.0f");
            }
        }
        return null;
    }    
}