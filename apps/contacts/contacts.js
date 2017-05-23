var maxContacts = 0

var appName = "contacts"
if (apps[appName].phoneIndex == null) {
    apps[appName].phoneIndex = 1
}

$(function() {
    contacts_init()
    scrollTo()
})

function sort_apps(a, b) {
    return ($(b).data('index')) < ($(a).data('index')) ? 1 : -1
}

function scrollTo() {
    var target = $(".contact").eq(apps[appName].phoneIndex)
    $("#contacts").scrollTop(target.index() * target.outerHeight())
}

function contacts_init() {
    $("#phone-content").css("background-image", "none")
    $("#phone-content").css("background-color", "#fafafa")
    $("#contacts").find(".contact").each(function(index, element) {
        maxContacts = index
    })
    $("#contacts").find(".contact").eq(apps[appName].phoneIndex).addClass("selected")
}

apps[appName].phoneUp = function() {
    $(".contact").eq(apps[appName].phoneIndex).removeClass("selected")
    if (apps[appName].phoneIndex - 1 >= 0) {
        apps[appName].phoneIndex -= 1
    }
    else {
        apps[appName].phoneIndex = maxContacts
    }
    scrollTo()
    $(".contact").eq(apps[appName].phoneIndex).addClass("selected")
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneDown = function() {
    $(".contact").eq(apps[appName].phoneIndex).removeClass("selected")
    if (apps[appName].phoneIndex + 1 <= maxContacts) {
        apps[appName].phoneIndex += 1
    }
    else {
        apps[appName].phoneIndex = 0
    }
    scrollTo()
    $(".contact").eq(apps[appName].phoneIndex).addClass("selected")
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneLeft = function() {

    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneRight = function() {

    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneCancel = function() {
    $(".contact").eq(apps[appName].phoneIndex).removeClass("selected")
    showApp("menu")
    playSound("BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneSelect = function() {
    var data = $(".contact").eq(apps[appName].phoneIndex)

    //sendData("app-" + data.data("trigger"), data.data("return"));
    playSound("SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET");
}
