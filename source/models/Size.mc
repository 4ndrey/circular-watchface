import Toybox.Graphics;
import Toybox.Lang;

class Size {
    var width;
    var height;

    function initialize(_width, _height) {
        width = _width;
        height = _height;
    }

    static function of(dc, placeholder, font) {
        var dim = dc.getTextDimensions(placeholder, font) as Array<Number>;
        return new Size(dim[0], dim[1]);
    }
}