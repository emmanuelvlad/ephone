var appName = "contacts"

var maxContacts = 0

if (apps[appName].firstLoad == null) {
    apps[appName].firstLoad = true
}

if (apps[appName].phoneIndex == null) {
    apps[appName].phoneIndex = 0
}
apps[appName].sections["creator"].elementIndex = 0;


function sort_apps(a, b) {
    return ($(b).data('index')) < ($(a).data('index')) ? 1 : -1
}

function scrollTo() {
    var target = $(".contact").eq(apps[appName].phoneIndex)
    $("#contacts").scrollTop((target.index() * target.outerHeight()) - 45)
}

function phoneFormat(number) {
    number = number.toString()
    if (number.length === 10) {
        return '(' + number.substr(0, 3) + ')' + number.substr(3, 3) + '-' + number.substr(6,4)
    } else {
        return number
    }
}

apps[appName].init = function() {
    $("#phone-content").css("background-image", "none")
    $("#phone-content").css("background-color", "#fafafa")
    $(".contact-section").find(".contact").each(function(index, element) {
        maxContacts = index
    })

    $("#contacts").find(".contact").eq(apps[appName].phoneIndex).addClass("selected")
    scrollTo()
}

apps[appName].terminate = function () {
}

apps[appName].update = function (data) {
    $(".contact-section").empty()
    $.each(data, function(index, element) {
        $(".contact-section").append(`
            <div class="contact">
            <img class="avatar" src="../html/background.jpg">
                <div class="name">${element.name} - ${phoneFormat(element.phone_number)}</div>
            </div>
        `)
    })
    apps[appName].init()
}

$(function() {
    if (apps[appName].firstLoad) { sendData("getContacts", {}); apps[appName].firstLoad = false }
})

apps[appName].phoneUp = function() {
    if (apps[appName].sections["creator"].displayed && !apps[appName].sections["creator"].write_mode) {
        var el = $(".section-content").children();
        el.eq(apps[appName].sections["creator"].elementIndex).removeClass("focus");
        if (apps[appName].sections["creator"].elementIndex - 1 >= 0) {
            apps[appName].sections["creator"].elementIndex  -= 1
        }
        else {
            apps[appName].sections["creator"].elementIndex  = 2
        }
        el.eq(apps[appName].sections["creator"].elementIndex).addClass("focus");
    } else {
        if ($("#add-contact").hasClass("selected")) {
            $("#add-contact.selected").removeClass("selected")
        }
        $(".contact").eq(apps[appName].phoneIndex).removeClass("selected")
        if (apps[appName].phoneIndex - 1 >= 0) {
            apps[appName].phoneIndex -= 1
        }
        else {
            apps[appName].phoneIndex = maxContacts
        }
        scrollTo()
        $(".contact").eq(apps[appName].phoneIndex).addClass("selected")
    }

    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneWheelUp = function() {
    apps[appName].phoneUp()
}

apps[appName].phoneDown = function() {
    if (apps[appName].sections["creator"].displayed && !apps[appName].sections["creator"].write_mode) {
        var el = $(".section-content").children();
        el.eq(apps[appName].sections["creator"].elementIndex).removeClass("focus");
        if (apps[appName].sections["creator"].elementIndex + 1 <= 2) {
            apps[appName].sections["creator"].elementIndex  += 1
        }
        else {
            apps[appName].sections["creator"].elementIndex  = 0
        }
        el.eq(apps[appName].sections["creator"].elementIndex).addClass("focus");
    } else {
        if ($("#add-contact").hasClass("selected")) {
            $("#add-contact.selected").removeClass("selected")
        }
        $(".contact").eq(apps[appName].phoneIndex).removeClass("selected")
        if (apps[appName].phoneIndex + 1 <= maxContacts) {
            apps[appName].phoneIndex += 1
        }
        else {
            apps[appName].phoneIndex = 0
        }
        scrollTo()
        $(".contact").eq(apps[appName].phoneIndex).addClass("selected")
    }
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneWheelDown = function() {
    apps[appName].phoneDown()
}

apps[appName].phoneLeft = function() {
    if ($("#add-contact").hasClass("selected")) {
        $("#add-contact.selected").removeClass("selected")
        $(".contact").eq(apps[appName].phoneIndex).addClass("selected")
    }
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneRight = function() {
    $("#add-contact").addClass("selected")
    $(".contact.selected").removeClass("selected")
    playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneCancel = function() {
    if (apps[appName].sections["creator"].displayed) {
        if (apps[appName].sections["creator"].write_mode) {
            sendData("enableCursor", {cursor: false});
            apps[appName].sections["creator"].write_mode = false;
        } else {
            $("#creator").remove();
            $("#phone-content").append(apps[appName].data);
            apps[appName].sections["creator"].displayed = false;
            $("#add-contact").removeClass("selected");
            $("#contacts").find(".contact").eq(apps[appName].phoneIndex).addClass("selected");
        }
    } else {
        $(".contact").eq(apps[appName].phoneIndex).removeClass("selected")
        showApp("menu")
    }

    playSound("BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET")
}

apps[appName].phoneSelect = function() {
    if (apps[appName].sections["creator"].displayed) {
        if (!apps[appName].sections["creator"].write_mode) {
            var el = $(".section-content").children().eq(apps[appName].sections["creator"].elementIndex);
            if (apps[appName].sections["creator"].elementIndex == 2) {
                el.click();
                var name = $("input.name").val();
                var number = $("input.number").val();
                apps[appName].phoneCancel();
                sendData("addContact", {name: name, phone_number: number})
            } else {
                sendData("enableCursor", {cursor: true});
                apps[appName].sections["creator"].write_mode = true;
                el.focus();
            }
        }
    } else {
        if ($("#add-contact").hasClass("selected")) {
            $("#contacts").remove();
            $("#phone-content").append(apps[appName].sections["creator"].data);
            apps[appName].sections["creator"].displayed = true;
            $(".section-content").children().eq(apps[appName].sections["creator"].elementIndex).addClass("focus");
        } else {
            var data = $(".contact").eq(apps[appName].phoneIndex)
        }

        //sendData("app-" + data.data("trigger"), data.data("return"));
    }

    playSound("SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET");
}
