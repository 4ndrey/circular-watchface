import Toybox.Graphics;

class Colors {
    static var backgroundColor = Graphics.COLOR_WHITE; 
    static var foregroundColor = Graphics.COLOR_BLACK;
    static var foregroundColorAlt = Graphics.COLOR_DK_GRAY;

    static function setDarkMode(isDarkMode) {
        backgroundColor = isDarkMode ? Graphics.COLOR_BLACK : Graphics.COLOR_WHITE; 
        foregroundColor = isDarkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
        foregroundColorAlt = isDarkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_DK_GRAY;
    }
}
