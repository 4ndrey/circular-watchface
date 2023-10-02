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
    private var hasAA;
    
    var seconds;

    function initialize(params) {
        Drawable.initialize(params);
        radius = System.getDeviceSettings().screenHeight / 2;
        penWidth = System.getDeviceSettings().screenHeight / 12 + 3;
        hasAA = Toybox.Graphics.Dc has :setAntiAlias;
    }

    function setSegments(_segments as Array<Segment>) {
        segments = _segments;
        segmentSize = 360.0 / _segments.size();
    }

    function draw(dc as Dc) as Void {
        if (hasAA) {
            dc.setAntiAlias(true);
        }

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

        // Draw first segment on top one more time to fix overlapping issue
        var lastSegment = tiles[tiles.size() - 1];
        if (lastSegment.value > 0.87) {
            var mid = start + (1.0 - lastSegment.value) * segmentSize;
            _drawSegment(dc, 0, mid, 0, lastSegment as Segment);
        }

        if (seconds != null) {
            // Draw seconds
            dc.setColor(Colors.foregroundColor, Colors.backgroundColor);
            dc.setPenWidth(4);
            var secondsAngle = -seconds * 6 + 90;
            dc.drawArc(radius, radius, radius - 1, Graphics.ARC_CLOCKWISE, secondsAngle + 2.5, secondsAngle - 2.5);
        }
        
        if (hasAA) {
            dc.setAntiAlias(false);
        }            
    }

    hidden function _drawSegment(dc as Dc, start, mid, end, segment as Segment) {
        var isFix = start == 0 && end == 0;
        var midAngle = mid * toPi;
        end = isFix ? mid + 5 : end;
        var endAngle = end * toPi;

        dc.setPenWidth(penWidth + 1);
        dc.setColor(segment.color(), Colors.foregroundColor);

        if (!isFix) {
            // Draw inactive segment arc
            for (var i = 10; i < (mid - start - 5); i = i + 9) {
                var mx = radius - (radius - 10) * Math.sin((start + i - 90) * toPi);
                var my = radius - (radius - 10) * Math.cos((start + i - 90) * toPi);
                dc.fillCircle(mx, my, 2);
            }
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
        var iconAngle = midAngle;
        x = radius + Math.cos(iconAngle) * (radius - penWidth / 2);
        y = radius - Math.sin(iconAngle) * (radius - penWidth / 2);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT); 
        dc.drawText(x, y, Fonts.iconsFont, segment.icon(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw label
        if (segment.label != null) {
            iconAngle = midAngle + 0.2;
            x = radius + Math.cos(iconAngle) * (radius - penWidth / 2 - 0.5);
            y = radius - Math.sin(iconAngle) * (radius - penWidth / 2 - 0.5);
            dc.setColor(Graphics.COLOR_WHITE, segment.color());
            dc.drawText(x, y, 
                Graphics.FONT_SYSTEM_XTINY, segment.label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }
    }

}
