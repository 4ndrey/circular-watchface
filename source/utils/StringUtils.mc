import Toybox.Lang;

function stringReplace(str, oldString, newString)
{
    var result = str;
    var index = result.find(oldString);

    if (index != null) {
        var index2 = index + oldString.length();
        return result.substring(0, index) + newString + result.substring(index2, result.length());
    } else {
        return result;
    }
}