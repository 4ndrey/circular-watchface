class WeatherData {
    var minTemperature;
    var maxTemperature;
    var currentTemperature;
    var forecasts = [];
    var upcomingWeatherCondition; // deprecated

    function isValid() {
        return minTemperature != null &&
            maxTemperature != null &&
            currentTemperature != null &&
            upcomingWeatherCondition != null;
    }

    function ratio() {
        if (maxTemperature == null || minTemperature == null || currentTemperature == null) {
            return 0;
        }
        if (maxTemperature == minTemperature) {
            return 0;
        }
        var ratio = (currentTemperature - minTemperature) * 1.0 / (maxTemperature - minTemperature);
        ratio = ratio < 0 ? 0 : ratio;
        ratio = ratio > 1 ? 1.0 : ratio;
        return ratio;
    }

    function weatherType() {
        if (upcomingWeatherCondition == null) {
            return null;
        }
        switch (upcomingWeatherCondition) {
            case Weather.CONDITION_CLEAR:
                return WEATHER_TYPE_CLEAR;
            case Weather.CONDITION_PARTLY_CLOUDY:
                return WEATHER_TYPE_FEW_CLOUDS;
            case Weather.CONDITION_MOSTLY_CLOUDY:
                return WEATHER_TYPE_BROKEN_CLOUDS;
            case Weather.CONDITION_RAIN:
                return WEATHER_TYPE_RAIN;
            case Weather.CONDITION_SNOW:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_WINDY:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_THUNDERSTORMS:
                return WEATHER_TYPE_THUNDER;
            case Weather.CONDITION_WINTRY_MIX:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_FOG:
                return WEATHER_TYPE_MIST;
            case Weather.CONDITION_HAZY:
                return WEATHER_TYPE_MIST;
            case Weather.CONDITION_HAIL:
                return WEATHER_TYPE_MIST;
            case Weather.CONDITION_SCATTERED_SHOWERS:
                return WEATHER_TYPE_SHOWER_RAIN;
            case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
                return WEATHER_TYPE_THUNDER;
            case Weather.CONDITION_LIGHT_RAIN:
                return WEATHER_TYPE_RAIN;
            case Weather.CONDITION_HEAVY_RAIN:
                return WEATHER_TYPE_SHOWER_RAIN;            
            case Weather.CONDITION_LIGHT_SNOW:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_HEAVY_SNOW:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_LIGHT_RAIN_SNOW:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_HEAVY_RAIN_SNOW:
                return WEATHER_TYPE_SHOWER_RAIN;
            case Weather.CONDITION_CLOUDY:
                return WEATHER_TYPE_FEW_CLOUDS;
            case Weather.CONDITION_RAIN_SNOW:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_PARTLY_CLEAR:
                return WEATHER_TYPE_CLEAR;
            case Weather.CONDITION_MOSTLY_CLEAR:
                return WEATHER_TYPE_CLEAR;
            case Weather.CONDITION_LIGHT_SHOWERS:
                return WEATHER_TYPE_RAIN;
            case Weather.CONDITION_SHOWERS:
                return WEATHER_TYPE_SHOWER_RAIN;
            case Weather.CONDITION_HEAVY_SHOWERS:
                return WEATHER_TYPE_SHOWER_RAIN;            
            case Weather.CONDITION_CHANCE_OF_SHOWERS:
                return WEATHER_TYPE_RAIN;            
            case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                return WEATHER_TYPE_THUNDER;
            case Weather.CONDITION_MIST:
                return WEATHER_TYPE_MIST;
            case Weather.CONDITION_DUST:
                return WEATHER_TYPE_MIST;
            case Weather.CONDITION_DRIZZLE:
                return WEATHER_TYPE_RAIN;
            case Weather.CONDITION_TORNADO:
                return WEATHER_TYPE_THUNDER;
            case Weather.CONDITION_SMOKE:
                return WEATHER_TYPE_MIST;
            case Weather.CONDITION_ICE:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_HAZE:
                return WEATHER_TYPE_MIST;            
            case Weather.CONDITION_TROPICAL_STORM:
                return WEATHER_TYPE_THUNDER;
            case Weather.CONDITION_CHANCE_OF_SNOW:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                return WEATHER_TYPE_RAIN;
            case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                return WEATHER_TYPE_SHOWER_RAIN;
            case Weather.CONDITION_FREEZING_RAIN:
                return WEATHER_TYPE_RAIN;
            case Weather.CONDITION_SLEET:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_ICE_SNOW:
                return WEATHER_TYPE_SNOW;
            case Weather.CONDITION_THIN_CLOUDS:
                return WEATHER_TYPE_SCAT_CLOUDS;
            default:
                return WEATHER_TYPE_FEW_CLOUDS;
        }
    }
}

class Forecast {
    var time;
    var color;

    function initialize(_color, _time) {
        time = _time;
        color = _color;
    }
}