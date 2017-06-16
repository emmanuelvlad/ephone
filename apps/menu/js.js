var appName = "menu"

var appsPerPage = 12
var appsPerLine = 3

var maxpage = 0

if (apps[appName].phoneIndex == null) {
    apps[appName].phoneIndex = 0
}
if (apps[appName].pageIndex == null) {
    apps[appName].pageIndex = 0
}

var pages = []

function sort_apps(a, b) {
    return ($(b).data('index')) < ($(a).data('index')) ? 1 : -1
}

function showPage(page) {
    $(".menu").find(".application").each(function(index, element) {
        $(this).remove()
    })
    $(".page").eq(apps[appName].pageIndex).removeClass("selected")
    $(".page").eq(page).addClass("selected")
    $(".menu").append(apps[appName].pages[page].data)
    apps[appName].pageIndex = page
}

apps[appName].init = function () {
    $("#phone-content").css("background-image", "url('https://thechive.files.wordpress.com/2015/01/i-think-its-time-for-a-new-phone-background-50-photos-4.jpg')")
    $(".menu .application").sort(sort_apps).appendTo('.menu')
    if (apps[appName].pages == null) {
        $(".menu").find(".application").each(function(index, element) {
            var page = Math.floor(index / (appsPerPage - appsPerLine))
            maxpage = page
            if (pages[page] == null) {
                pages[page] = {}
            }
            if (pages[page].data == null) {
                pages[page].data = []
            }
            pages[page].apps = index % (appsPerPage - appsPerLine)
            pages[page].data.push($(this).detach())
        })
        apps[appName].pages = pages
        apps[appName].maxpage = maxpage
    }

    $("#pagination").empty()
    $.each(apps[appName].pages, function(index, element) {
        $("#pagination").append('<span class="page"></span>')
    })
    showPage(apps[appName].pageIndex)
    $(".menu").find(".application").eq(apps[appName].phoneIndex).addClass("selected")
}

apps[appName].terminate = function () {
}

$(function() {
    apps[appName].init()
})

apps[appName].phoneUp = function() {
    $(".application").eq(apps[appName].phoneIndex).removeClass("selected")
    if (apps[appName].phoneIndex - appsPerLine >= 0) {
        apps[appName].phoneIndex -= appsPerLine
    }
    else {
        apps[appName].phoneIndex = (apps[appName].pages[apps[appName].pageIndex].apps) + ((apps[appName].phoneIndex % appsPerLine) + 1)
    }
    $(".application").eq(apps[appName].phoneIndex).addClass("selected")
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneDown = function() {
    $(".application").eq(apps[appName].phoneIndex).removeClass("selected")
    if (apps[appName].phoneIndex + (appsPerLine - 1) < apps[appName].pages[apps[appName].pageIndex].apps + appsPerLine) {
        apps[appName].phoneIndex += appsPerLine
    }
    else {
        apps[appName].phoneIndex = (apps[appName].phoneIndex % appsPerLine)
    }
    $(".application").eq(apps[appName].phoneIndex).addClass("selected")
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneLeft = function() {
    $(".application").eq(apps[appName].phoneIndex).removeClass("selected")
    if (apps[appName].phoneIndex % appsPerLine > 0) {
        apps[appName].phoneIndex -= 1
    }
    else {
        if (apps[appName].pageIndex > 0) {
            showPage(apps[appName].pageIndex - 1)
            apps[appName].phoneIndex += appsPerLine - 1
        }
        else if (apps[appName].phoneIndex > 0) {
            apps[appName].phoneIndex -= 1
        }
        else {
            apps[appName].phoneIndex = appsPerPage - 1
        }
    }
    $(".application").eq(apps[appName].phoneIndex).addClass("selected")
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneRight = function() {
    $(".application").eq(apps[appName].phoneIndex).removeClass("selected")
    if (apps[appName].phoneIndex % appsPerLine < (apps[appName].pages[apps[appName].pageIndex].apps + appsPerLine) % appsPerLine) {
        apps[appName].phoneIndex += 1
    }
    else {
        if (apps[appName].pageIndex < apps[appName].maxpage) {
            showPage(apps[appName].pageIndex + 1)
            apps[appName].phoneIndex = (apps[appName].phoneIndex % (apps[appName].pages[apps[appName].pageIndex].apps + appsPerLine + 1)) - ((apps[appName].phoneIndex % (apps[appName].pages[apps[appName].pageIndex].apps + appsPerLine + 1)) % (appsPerLine))
        }
        else if (apps[appName].phoneIndex < (apps[appName].pages[apps[appName].pageIndex].apps + appsPerLine)) {
            apps[appName].phoneIndex += 1
        }
        else {
            apps[appName].phoneIndex = 0
        }
    }
    $(".application").eq(apps[appName].phoneIndex).addClass("selected")
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneCancel = function() {
    sendData("phoneClose", {})
    playSound("BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneSelect = function() {
    var data = $(".application").eq(apps[appName].phoneIndex)

    //sendData("app-" + data.data("trigger"), data.data("return"));
    showApp(data.data("trigger"))
    playSound("SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET");
}

apps[appName].phoneOption = function() {
}

apps[appName].phoneExtraOption = function() {
}
