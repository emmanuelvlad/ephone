
<template>
    <div>
        <img id="cursor" src="images/cursor.png" width="32" height="32">

        <div id="container">

            <transition
                name="custom-classes-transition"
                enter-active-class="animated slideInUp"
                leave-active-class="animated slideOutDown">

                <div
                    v-if="show"
                    id="phone">
                    <div id="phone-top">
                        <div id="phone-camera"></div>
                        <div id="phone-speaker"></div>
                    </div>

                    <div
                        id="phone-screen"
                        :style="battery > 0 ? 'background: url(\'images/background-1.jpg\')' : ''">

                        <template v-if="battery > 0">

                            <!-- Top bar -->
                            <div
                                v-if="statusBar.show"
                                id="statusBar"
                                :style="`background-color: ` + statusBar.background + '; color: ' + statusBar.color">
                                <div class="statusBar-content">
                                    <!-- Date -->
                                    <div class="statusBar-date">{{ date }}</div>
                                    <!-- Silenced -->
                                    <div
                                        v-if="silenced"
                                        class="statusBar-silence">
                                        <span
                                            class="mdi mdi-bell-off-outline"></span>
                                    </div>
                                    <!-- Network strenght -->
                                    <div class="statusBar-network">
                                        <span
                                            :class="'mdi mdi-network-strength-' + (network ? network : 'outline')"></span>
                                    </div>
                                    <!-- Battery -->
                                    <div
                                        :class="'statusBar-battery ' + (charging ? 'charge' : battery <= 15 ? 'low' : '')">
                                        <span
                                            :class="'mdi mdi-battery' + (charging ? '-charging' : '') + (batteryDecimal ? batteryDecimal === 100 ? '' : '-' + batteryDecimal : '-outline')"></span>
                                        <span>{{ battery }}%</span>
                                    </div>
                                </div>
                            </div>

                            <component :is="currentApp"></component>

                        </template>

                    </div>
                </div>
                
            </transition>

        </div>
    </div>
</template>

<script>
module.exports = {
    //
    // Name
    //
    name: "App",

    //
    // Components
    //
    components: {
        AppMenu: httpVueLoader("apps/menu.vue")
    },

    //
    // Data
    //
    data() {
        return {
            show: true,
            debug: true,
            currentApp: "AppMenu",
            action: "",
            date: "18:14",
            listener: null
        }
    },

    //
    // Computed
    //
    computed: {
        battery: {
            get() {
                return this.$store.getters.battery;
            },

            set(newValue) {
                return this.$store.commit("SET_BATTERY", newValue);
            }
        },

        network() {
            return this.$store.getters.network;
        },

        silenced() {
            return this.$store.getters.silenced
        },

        charging() {
            return this.$store.getters.charging
        },

        statusBar() {
            return this.$store.getters.statusBar
        },

        batteryDecimal() {
            if (this.battery >= 100) return 100;
            return Math.floor(this.battery / 10) * 10;
        }
    },

    //
    // Methods
    //
    methods: {
        sendData(name, data) {
            var request = new XMLHttpRequest();
            request.open("POST", "http://ephone/" + name, true);
            request.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
            request.send(JSON.stringify(data));
        },

        playSound(sound, soundset) {
            this.sendData("playSound", { name: sound, set: soundset });
        },

        buttonPressed(button) {
            this.$root.$emit("buttonPressed", button);
        }
    },

    //
    // Created
    //
    created() {
        this.debugListener = window.addEventListener("keydown", ({ key }) => {
            switch (key) {
                case "ArrowUp":
                    this.buttonPressed("up");
                    break;
                case "ArrowRight":
                    this.buttonPressed("right");
                    break;
                case "ArrowDown":
                    this.buttonPressed("down");
                    break;
                case "ArrowLeft":
                    this.buttonPressed("left");
                    break;
                case "Backspace":
                    this.buttonPressed("cancel");
                    break;
            }
        });
        this.battery = 75;

        // In game listener
        this.listener = window.addEventListener("message", ({ data }) => {
            if (data.date) {
                this.date = `${('0' + data.date.hours).slice(-2)}:${('0' + data.date.minutes).slice(-2)}`
            }

            this.charging = data.charging || false;

            if (data.battery >= 0) {
                this.battery = data.battery;
            }

            // Show phone
            if (data.show) {
                this.show = true;
                this.playSound("Pull_Out", "Phone_SoundSet_Michael")
            }
            // Hide phone
            else if (data.hide) {
                if (typeof apps[currentApp].terminate === 'function') {
                    apps[currentApp].terminate()
                }
                this.show = false;
                this.playSound("Put_Away", "Phone_SoundSet_Michael")
            }

            if (data.update) {
                update[data.update.name] = data.update
            }

            if (data.buttonPressed) {
                this.buttonPressed(data.buttonPressed);
                this.action = data.buttonPressed
            }
        });
    },

    //
    // Destroyed
    //
    destroyed() {
        window.removeEventListener("message", this.listener);
        window.removeEventListener("message", this.debugListener);
    },

    //
    // Watch
    //
    watch: {
        battery(value) {
            if (value <= 15 && value % 5 == 0 && !charging) {
                var audio = new Audio("../sounds/lowBattery.ogg");
                audio.volume = 0.15;
                audio.play();
            }
        },

        charging(value) {
            if (value) {
                var audio = new Audio("../sounds/chargerConnection.ogg");
                audio.volume = 0.15;
                audio.play();
            }
        }
    }
}
</script>

<style>
#container
{
    position: fixed;
    bottom: 0px;
    width: 300px;
    right: 5%;
}

#phone
{
    position: relative;
    background: -webkit-linear-gradient(left, #4A4F57 0%,#3d4247 100%);
    border-radius: 40px 40px 0 0;
    height: 475px;
    padding: 30px 7px 0 7px;
    width: 290px;
    bottom: 0;
}

#phone::after
{
    position: absolute;
    z-index: -1;
    content: '';
    background: -webkit-linear-gradient(left, #2a2f38 0%,#2e313d 100%);
    border-radius: 40px 40px 0 0;
    top: -4px;
    right: -4px;
    bottom: 0;
    left: 0;
}

#phone-screen
{
    position: relative;
    display: inline-block;
    background-color: #0a0a0a;
    background-repeat: no-repeat;
    background-size: cover;
    background-position: center;
    border-width: 1px 1px 0px 1px;
    border-style: solid;
    border-color: #5d5d5d;
    height: 100%;
    width: 100%;
    border-radius: 30px 30px 0 0;
    overflow: hidden;
}

#blackout
{
    background: black;
    height: 100%;
    width: 100%;
    z-index: 5;
    border-radius: 10px 10px 0 0;
}

#statusBar
{
    padding: 3px 10px;
    height: 18px;
    border-radius: 5px 5px 0 0;
    color: #fff;
}

#statusBar div
{
    display: inline-flex;
    margin: 0 5px 0 5px;
    position: relative;
    height: 20px;
    overflow: hidden;
    text-align: center;
    font-size: 14px;
    line-height: 20px;
    align-items: center;
    vertical-align: middle;
}

.statusBar-date
{

}

.statusBar-battery
{
}

.statusBar-battery.low
{
    color: red;
}

.statusBar-battery.charge
{
    color: green;
}

.battery-bar
{
    width: 100%;
    border: 1px solid red;
}

#cursor {
    position: absolute;
    z-index: 999;
    display: none;
}

.cursor-pointer {
    cursor: pointer;
}

.cursor-text {
    cursor: text;
}

#phone-camera {
    position: absolute;
    border-radius: 100%;
    z-index: 9;
    background: -webkit-radial-gradient(center, ellipse cover, #333 0%,#222 100%);
    width: 18px;
    height: 18px;
    top: 6px;
    right: 0;
    bottom: 0;
    left: 35px;
}

#phone-speaker {
    position: absolute;
    border-radius: 5px;
    z-index: 9;
    background: -webkit-radial-gradient(center, ellipse cover, #333 0%,#222 100%);
    width: 125px;
    height: 4px;
    top: 10px;
    right: 0;
    bottom: 0;
    left: 100px;
}
</style>
