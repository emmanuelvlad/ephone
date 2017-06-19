var charger_connection_sound = "chargerConnection.ogg" // .ogg files please
var low_battery_sound = "lowBattery.ogg" // .ogg files please

var apps = []

var currentApp = "menu"

function sendData(name, data) {
    $.post("http://ephone/" + name, JSON.stringify(data), function(data) {})
}

function playSound(sound, soundset) {
    sendData("playSound", {name: sound, set: soundset});
}

function sendMessage(string) {
    sendData("message", {message: string.toString()});
}

$(function() {
    init()

    window.addEventListener("message", function(event) {
        var data = event.data

        if (data.date) {
            updateDate(data.date)
        }

        if (data.battery >= 0) {
            if (data.lowBattery && !data.charging) {
                lowBattery(data)
            }
            else if (data.charging && !data.lowBattery) {
                if (data.chargerConnected) {
                    var audio = new Audio(`../sounds/${charger_connection_sound}`)
                    audio.volume = data.volume
                    audio.play()
                }
                chargeBattery(data.battery)
            }
            updateBattery(data)
        }

        if (data.show) {
            $("#container").slideDown(500)
            playSound("Pull_Out", "Phone_SoundSet_Michael")
        }
        else if (data.hide) {
            if (typeof apps[currentApp].terminate === 'function') {
                apps[currentApp].terminate()
            }
            $("#container").slideUp(500)
            playSound("Put_Away", "Phone_SoundSet_Michael")
        }

        if (data.select) {
            apps[currentApp].phoneSelect()
        }
        else if (data.cancel) {
            apps[currentApp].phoneCancel()
        }
        else if (data.up) {
            apps[currentApp].phoneUp()
        }
        else if (data.down) {
            apps[currentApp].phoneDown()
        }
        else if (data.left) {
            apps[currentApp].phoneLeft()
        }
        else if (data.right) {
            apps[currentApp].phoneRight()
        }
        else if (data.option) {
            apps[currentApp].phoneOption()
        }
        else if (data.extra_option) {
            apps[currentApp].phoneExtraOption()
        }
    })
})

function showApp(appname) {
    if (apps[appname]) {
        $(`#${currentApp}`).remove()
        $.getScript(`../apps/${appname}/js.js`)
        $("#phone-content").append(apps[appname].data)
        currentApp = appname
    }
}

function init() {
    $("*[data-app]").each(function(element, index) {
        var name = $(this).data("app")

        apps[name] = {}
        apps[name].sections = [];

        $(this).load(`../apps/${name}/html.html`, function(response, status, xhr) {
            if (status !== "error") {
                $(this).html(response)
            }
        })
        apps[name].data = $(this).detach()
        apps[name].init = false

        $(this).children("*[data-app-section]").each(function (element, index) {
            var section_name = $(this).data("app-section");

            apps[name].sections[section_name] = {};

            $(this).load(`../apps/${name}/${section_name}/html.html`, function(response, status, xhr) {
                if (status !== "error") {
                    $(this).html(response)
                }
            })

            apps[name].sections[section_name].data = $(this).detach();
            apps[name].sections[section_name].displayed = false;

        })
    })
    showApp("menu")
}

function updateDate(date) {
    $(".top-date").html(`${('0' + date.hours).slice(-2)}:${('0' + date.minutes).slice(-2)}`)
}

function updateBattery(data) {
    $(".top-battery").html(data.battery)
    if (data.battery > 15 && $(".top-battery").hasClass("battery-low")) {
        $(".top-battery").removeClass("battery-low")
    } else if (data.battery <= 15 && !$(".top-battery").hasClass("battery-low")) {
        $(".top-battery").addClass("battery-low")
    }

    if (!data.charging && $(".top-battery").hasClass("battery-charge")) {
        $(".top-battery").removeClass("battery-charge")
    }

    if (data.battery == 0) {
        $("#blackout").show()
        $("#phone-content").hide()
    } else {
        $("#blackout").hide()
        $("#phone-content").show()
    }
}

function lowBattery(data) {
    if (data.battery <= 15 && data.battery % 5 == 0) {
        var audio = new Audio(`../sounds/${low_battery_sound}`)
        audio.volume = data.volume
        audio.play()
    }
}

function chargeBattery(battery) {
    if (!$(".top-battery").hasClass("battery-charge")) {
        $(".top-battery").addClass("battery-charge")
    }
}
