import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class CircularView extends WatchUi.WatchFace {

    private var _dataProvider;
    private var _fonts;
    private var _layout;

    private var needsPartialUpdate = false;

    function initialize() {
        WatchFace.initialize();

        _dataProvider = new DataProvider();
        _layout = new Layout();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

        if (_layout.needsUpdate) {
            Fonts.load();
            _layout.update(
                dc,
                Size.of(dc, "00", Fonts.bigFont),
                Size.of(dc, "00", Fonts.mediumFont),
                Size.of(dc, "Xxx 00", Fonts.smallFont)
            );
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        Fonts.load();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var hoursValue = _dataProvider.getHour();
        var hours = hoursValue.format("%02d").toString();
        var minutes = _dataProvider.getMinutes();

        var darkMode = Application.Properties.getValue("DarkMode");
        if (darkMode == 0 /* Auto */) {
            Colors.setDarkMode(hoursValue >= 21 || hoursValue <= 6);
        } else if (darkMode == 1) {
            Colors.setDarkMode(true);
        } else {
            Colors.setDarkMode(false);
        }
        
        var activityRing = View.findDrawableById("ActivityRing") as ActivityRing;
        activityRing.setSegments(_dataProvider.getSegments());

        var hoursView = View.findDrawableById("Hours") as Label;
        hoursView.text = hours;
        hoursView.font = Fonts.bigFont;
        hoursView.origin = _layout.hoursPosition;

        var minutesView = View.findDrawableById("Minutes") as Label;
        minutesView.text = minutes;
        minutesView.font = Fonts.mediumFont;
        minutesView.origin = _layout.minutesPosition;

        var date = View.findDrawableById("Date") as Label;
        date.text = _dataProvider.getDate();
        date.font = Fonts.smallFont;
        date.origin = _layout.datePosition;
        date.alignment = Graphics.TEXT_JUSTIFY_CENTER;

        var complicationView = View.findDrawableById("Complication") as Complication;
        complicationView.origin = _layout.weatherPosition;
        complicationView.heartRateData = _dataProvider.getHeartRate();
        complicationView.weatherData = _dataProvider.getWeatherData();
        needsPartialUpdate = complicationView.needsUpdate;

        if (Application.Properties.getValue("NotificationsBadge")) {
            var notificationsView = View.findDrawableById("Notifications") as NotificationsView;
            notificationsView.origin = _layout.notificationsPosition;
            notificationsView.updateWith(_dataProvider.notificationsCount());
        }
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Partial updates
	function onPartialUpdate(dc) {
        if (needsPartialUpdate) {
            var complicationView = View.findDrawableById("Complication") as Complication;
            complicationView.heartRateData = _dataProvider.getHeartRate();
        }
	}

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        Fonts.unload();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
