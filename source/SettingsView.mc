using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;

const _clearReminderKey = "clear_reminder";

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
        }
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }    
}
