// URL public static:
function urlPublicStatic(route, path) {
    var value = "https://" + route + path
    mainWindow.logMessage(value)
    return value
}

// URL play:
function urlPlay(ip, path) {
    var url = "http://" + ip + ":9000" + path
    mainWindow.logMessage(url)
    return url
}

// String compare:
function stringCompare(str1, str2)
{
    str1.replace(" ", "")
    str2.replace(" ", "")
    return str1.toLowerCase() === str2.toLowerCase()
}

// Static no cache of URL:
function staticNoCacheOf(route, url) {
    var fakeVersionCacheBuster = Date.now()
    var urlUnique = url + "?v=" + fakeVersionCacheBuster
    return urlPublicStatic(route, urlUnique)
}

