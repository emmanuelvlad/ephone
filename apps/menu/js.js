var appName = "menu"

var appsPerPage = 12
var appsPerLine = 3

var maxpage = 0

if (apps[appName].firstLoad == null) {
    apps[appName].firstLoad = true
}

if (apps[appName].phoneIndex == null) {
    apps[appName].phoneIndex = 9
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

apps[appName].reset = function () {
    $(".menu").empty()
    $("#pagination").empty()
    apps[appName].pages = null
    apps[appName].maxpage = null
    pages = []
}

apps[appName].init = function () {
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

apps[appName].update = function (data) {
    if (data.menu && data.apps) {
        apps[appName].reset()
        $.each(data.menu, function(index, element) {
            var app = getApp(data.apps, element.appid)
            $(".menu").append(`
                <div class="application app-${app.name}" data-trigger="${app.name}" data-index="${element.index}">
                    <div class="icon"><i class="material-icons">${app.icon}</i></div>
                    <p>${app.display_name}</p>
                </div>
            `)
        })
        apps[appName].init()
    }
}

function getApp(apps, appid) {
    var ret = null
    $.each(apps, function(index, element) {
        if (element.id === appid) {
            ret = element
        }
    })
    return ret
}

$(function() {
    $("#phone-content").css("background-image", "url('../html/background.jpg')")
    if (apps[appName].firstLoad) {
        sendData("getMenu", {})
        apps[appName].firstLoad = false
    }
})

apps[appName].phoneUp = function() {
    $(".application").eq(apps[appName].phoneIndex).removeClass("selected")
    if (apps[appName].phoneIndex - appsPerLine + ((apps[appName].pages[apps[appName].pageIndex].apps + 1) % appsPerLine) >= 0) {
        if (apps[appName].phoneIndex - appsPerLine > appsPerLine) {
            apps[appName].phoneIndex -= appsPerLine - ((apps[appName].pages[apps[appName].pageIndex].apps + 1) % appsPerLine)
        } else {
            apps[appName].phoneIndex -= appsPerLine
        }
    }
    else {
        apps[appName].phoneIndex = (apps[appName].pages[apps[appName].pageIndex].apps) + ((apps[appName].phoneIndex % appsPerLine) + 1)
    }
    $(".application").eq(apps[appName].phoneIndex).addClass("selected")
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneWheelUp = function() {
    apps[appName].phoneUp()
}

apps[appName].phoneDown = function() {
    $(".application").eq(apps[appName].phoneIndex).removeClass("selected")
    if (apps[appName].phoneIndex + (appsPerLine - 1) < apps[appName].pages[apps[appName].pageIndex].apps + appsPerLine) {
        apps[appName].phoneIndex += appsPerLine
    }
    else {
        if ((apps[appName].pages[apps[appName].phoneIndex].apps + 1) % 3 === 1) {
            apps[appName].phoneIndex -= 1
        } else {
            apps[appName].phoneIndex = (apps[appName].phoneIndex % appsPerLine)
        }
    }
    $(".application").eq(apps[appName].phoneIndex).addClass("selected")
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneWheelDown = function() {
    apps[appName].phoneDown()
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
            apps[appName].phoneIndex = apps[appName].pages[apps[appName].phoneIndex].apps + appsPerLine
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
    showApp($(".application").eq(apps[appName].phoneIndex).data("trigger"))
    playSound("SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET");
}

apps[appName].phoneOption = function() {
}

apps[appName].phoneExtraOption = function() {
}
