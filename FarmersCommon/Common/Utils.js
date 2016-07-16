// URL public static:
function urlPublicStatic(route, path) {
    if (path.length === 0)
        return "qrc:/assets/ico-question.png"
    var value = "https://" + route + path
    console.log(value)
    return value
}

// URL play:
function urlPlay(ip, path) {
    var url = "http://" + ip + ":9000" + path
    console.log(url)
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

// Object valid?
function objValid(object)
{
	return object && (typeof(object) !== "undefined")
}