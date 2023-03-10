import Toybox.Graphics;

class Layout {
    static private const timePadding = 10;

    var hoursPosition;
    var minutesPosition;
    var datePosition;
    var weatherPosition;

    var needsUpdate = true;

    function update(dc, hoursSize, minutesSize, dateSize) {
        var screenSize = new Size(dc.getWidth(), dc.getHeight());

        hoursPosition = new Point(
            (screenSize.width - hoursSize.width - minutesSize.width - timePadding) / 2,
            (screenSize.height - hoursSize.height) / 2
        );

        minutesPosition = new Point(
            hoursPosition.x + hoursSize.width + timePadding,
            hoursPosition.y + (hoursSize.height - minutesSize.height) / 2
        );

        datePosition = new Point(
            (screenSize.width - dateSize.width) / 2,
            (hoursPosition.y - dateSize.height + ActivityRing.penWidth) / 2
        );

        weatherPosition = new Point(
            screenSize.width / 2,
            screenSize.height * 3 / 4
        );

        needsUpdate = false;
    }
}