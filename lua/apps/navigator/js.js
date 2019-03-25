var appName = "navigator"

var cursor = document.getElementById("cursor")
if (cursorX == null) {
    var cursorX = document.documentElement.clientWidth/ 2
}
if (cursorY == null) {
    var cursorY = document.documentElement.clientHeight / 2
}

function updateMouse() {
    $("#cursor").css({"left": cursorX + 1, "top": cursorY + 1})
}

function rightClick(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
}

apps[appName].init = function() {
    $("#cursor").css("display", "block")
    updateMouse()
    $("#navigator").addClass('animate')
    sendData("enableCursor", {cursor: true})
}

apps[appName].terminate = function() {
    $("#cursor").css("display", "none")
    $("#navigator").removeClass('animate')
    sendData("enableCursor", {cursor: false})
    showApp("menu")
}

$(function() {
    apps[appName].init()
    window.addEventListener('message', function(event) {
        if (event.data.rightclick) {
            rightClick(cursorX - 1, cursorY - 1);
        }
    })

    $(document).mousemove(function(event) {
        cursorX = event.clientX
        cursorY = event.clientY
        updateMouse()
    })

    $("#navigator-close").click(function() {
        apps[appName].terminate()
    })

    $(".cursor-pointer").mouseenter(function() {
        $("#cursor").attr("src", "images/pointer.png")
        $("#cursor").css("margin-left", "-12px")
    }).mouseleave(function() {
        $("#cursor").attr("src", "images/cursor.png")
        $("#cursor").css("margin-left", "0")
    })

    $(".cursor-text").mouseenter(function() {
        $("#cursor").attr("src", "images/text.png")
    }).mouseleave(function() {
        $("#cursor").attr("src", "images/cursor.png")
    })
})

apps[appName].phoneUp = function() {
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneDown = function() {
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneLeft = function() {
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneRight = function() {
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneCancel = function() {
    apps[appName].terminate()
    playSound("BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneSelect = function() {
    playSound("SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET");
}

apps[appName].phoneOption = function() {
}

apps[appName].phoneExtraOption = function() {
}
