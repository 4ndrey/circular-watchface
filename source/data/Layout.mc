import Toybox.Graphics;

class Layout {
    static private const timePadding = 8;

    var hoursPosition;
    var minutesPosition;
    var datePosition;
    var weatherPosition;
    var notificationsPosition;

    var needsUpdate = true;

    function update(dc, hoursSize, minutesSize, dateSize) {
        var screenSize = new Size(dc.getWidth(), dc.getHeight());
        var dy = 5;

        hoursPosition = new Point(
            (screenSize.width - hoursSize.width - minutesSize.width - timePadding) / 2,
            (screenSize.height - hoursSize.height) / 2 - dy + 2
        );

        minutesPosition = new Point(
            hoursPosition.x + hoursSize.width + timePadding,
            hoursPosition.y + (hoursSize.height - minutesSize.height) / 2 - dy + 2
        );

        datePosition = new Point(
            screenSize.width / 2,
            (hoursPosition.y - dateSize.height + screenSize.width / 12 - dy) / 2 + 11
        );

        weatherPosition = new Point(
            screenSize.width / 2,
            screenSize.height * 3 / 4
        );

        notificationsPosition = new Point(
            datePosition.x + 1,
            datePosition.y - 7
        );

        needsUpdate = false;
    }
}