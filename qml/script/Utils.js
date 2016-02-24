// URL public static:
function urlPublicStatic(path) {
    var value = _controller.currentRoute + path
    console.log("URLPUBLICSTATIC: " + _controller.currentRoute + path)
    return value
}

// URL play:
function urlPlay(path) {
    var url = "http://" + _controller.currentIP + ":9000/" + path
    console.log("URLPLAY: " + url)
    return url
}

// String compare:
function stringCompare(str1, str2)
{
    str1.replace(" ", "")
    str2.replace(" ", "")
    return str1.toLowerCase() === str2.toLowerCase()
}

// Calculate scale:
function calculateScale(width, height, cellSize) {
    var widthScale = (cellSize * 1.0) / width
    var heightScale = (cellSize * 1.0) / height
    var scale = 0

    if (widthScale <= heightScale) {
        scale = widthScale;
    } else if (heightScale < widthScale) {
        scale = heightScale;
    }
    return scale;
}
