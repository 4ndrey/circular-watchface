import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;

class NotificationsView extends WatchUi.Drawable {

    var origin;
    var _notificationCount;
    var isVisible;

    function initialize(params) {
        Drawable.initialize(params);
        isVisible = false;
    }

    function updateWith(notificationCount) {
        _notificationCount = notificationCount;
        isVisible = _notificationCount != 0;
    }

    function draw(dc as Dc) as Void {
        if (!isVisible) { return; }

        dc.setPenWidth(dc.getHeight() / 20);
        dc.setColor(_notificationCount == null ? Graphics.COLOR_ORANGE : Colors.foregroundColor, Colors.backgroundColor);
        dc.drawCircle(origin.x, origin.y - 3, 5);
        dc.setColor(Colors.backgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            origin.x,
            origin.y - 4,
            Graphics.FONT_SYSTEM_XTINY,
            _notificationCount == null ? "!" : _notificationCount.toString(),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );        
    }

}
