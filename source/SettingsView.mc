using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;

const _clearReminderKey = "clear_reminder";
const _activeMinutesKey = "active_minutes";

class SettingsView extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Settings"});
        
        Menu2.addItem(
            new MenuItem(
                "Clear reminder",
                null,
                _clearReminderKey,
                {}
            )
        );

        Menu2.addItem(
            new MenuItem(
                "Toggle active minutes",
                null,
                _activeMinutesKey,
                {}
            )
        );        
	}
}

class SettingsDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        if (item.getId().equals(_clearReminderKey)) {
            Application.Properties.setValue("Notes", null);
            onBack();
        } else if (item.getId().equals(_activeMinutesKey)) {
            var toggle = Application.Properties.getValue("ActiveMinutesSegment");
            Application.Properties.setValue("ActiveMinutesSegment", !toggle);
            onBack();            
        }
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }    
}
