import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Math;
import Toybox.Lang;

class ActivityRing extends WatchUi.Drawable {

    private var penWidth;
    private static const toPi = Math.PI / 180;

    private var radius;
    private var segmentSize = 90.0;
    private var segments;

    function initialize(params) {
        Drawable.initialize(params);
        radius = System.getDeviceSettings().screenHeight / 2;
        penWidth = System.getDeviceSettings().screenHeight / 12 + 3;
    }

    function setSegments(_segments as Array<Segment>) {
        segments = _segments;
        segmentSize = 360.0 / _segments.size();
    }

    function draw(dc as Dc) as Void {
        // Draw background
        dc.setPenWidth(penWidth);
        dc.setColor(Colors.backgroundColor, Colors.backgroundColor);
        dc.drawArc(radius, radius, radius + penWidth / 2, Graphics.ARC_CLOCKWISE, 90, -270);

        var tiles = segments as Array<Segment>;
        var start = -270;
        for (var i = tiles.size() - 1; i >= 0; i--) {
            var value = tiles[i].value > 1 ? 1.0 : tiles[i].value;
            var mid = start + (1.0 - value) * segmentSize;
            var end = start + segmentSize;
            _drawSegment(dc, start, mid, end, tiles[i] as Segment);
            start = end;
        }
    }

    hidden function _drawSegment(dc as Dc, start, mid, end, segment as Segment) {
        var midAngle = mid * toPi;
        var endAngle = end * toPi;

        dc.setPenWidth(penWidth + 1);
        dc.setColor(segment.color(), Colors.foregroundColor);

        // Draw inactive segment arc
        // dc.drawArc(radius, radius, radius - penWidth / 2, Graphics.ARC_COUNTER_CLOCKWISE, start, mid);
        for (var i = 10; i < (mid - start - 5); i = i + 9) {
            var mx = radius - (radius - 10) * Math.sin((start + i - 90) * toPi);
            var my = radius - (radius - 10) * Math.cos((start + i - 90) * toPi);
            dc.fillCircle(mx, my, 2);
        }

        var x = 0;
        var y = 0;
        if ((mid - end).abs() > 1) {
            // Draw active segment arc
            dc.setColor(segment.color(), Colors.foregroundColor);
            dc.drawArc(radius, radius, radius - penWidth / 2, Graphics.ARC_COUNTER_CLOCKWISE, mid, end);
        } 

        // Add rounding to arc
        x = radius + Math.cos(midAngle) * (radius - penWidth / 2);
        y = radius - Math.sin(midAngle) * (radius - penWidth / 2);
        dc.fillCircle(x, y, penWidth / 2 + 3);

        x = radius + Math.cos(endAngle) * (radius - penWidth / 2);
        y = radius - Math.sin(endAngle) * (radius - penWidth / 2);
        dc.fillCircle(x, y, penWidth / 2);        

        // Draw segment icon
        var iconAngle = (mid + 1) * toPi;
        x = radius + Math.cos(iconAngle) * (radius - penWidth / 2);
        y = radius - Math.sin(iconAngle) * (radius - penWidth / 2);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT); 
        dc.drawText(x, y, Fonts.iconsFont, segment.icon(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw label
        if (segment.label != null) {
            iconAngle = (mid + 12.5) * toPi;
            x = radius + Math.cos(iconAngle) * (radius - penWidth / 2 - 0.5);
            y = radius - Math.sin(iconAngle) * (radius - penWidth / 2 - 0.5);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(x, y, 
                Graphics.FONT_SYSTEM_XTINY, segment.label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }
    }

}
