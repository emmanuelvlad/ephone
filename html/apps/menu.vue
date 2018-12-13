<template>
<div>

    <div class="menu">
        <div
            v-for="(app, index) in apps"
            :key="index"
            :class="'application app-' + app.name + ' ' + (selectedApp === index ? 'selected' : '')"
            :data-trigger="app.name"
            :data-index="index">
            <div class="icon">
                <span :class="'mdi mdi-' + app.icon"></span>
            </div>
            <p>{{ app.display_name }}</p>
        </div>
    </div>

    <div id="pagination">
    </div>

    <div id="sticky-menu">

        <div
            v-for="(app, index) in stickyApps"
            :key="index"
            :class="'application sticky-app app-' + app.trigger + ' ' + (selectedApp === appsPerPage + index ? 'selected' : '')"
            :data-trigger="app.trigger"
            :data-index="appsPerPage + index">
            <div class="icon">
                <span :class="'mdi mdi-' + app.icon"></span>
            </div>
        </div>

    </div>

</div>
</template>

<script>
module.exports = {
    //
    // Name
    //
    name: "Menu",

    //
    // Data
    //
    data() {
        return {
            selectedApp: 0,
            rows: 3,
            appsPerRow: 3,
            apps: [
                {
                    name: "test",
                    display_name: "Lol",
                    icon: "alpha-a-circle"
                },
                {
                    name: "test",
                    display_name: "Lol",
                    icon: "alpha-a-circle"
                },
                {
                    name: "test",
                    display_name: "Lol",
                    icon: "alpha-a-circle"
                },
                {
                    name: "test",
                    display_name: "Lol",
                    icon: "alpha-a-circle"
                }
            ],
            stickyApps: [
                {
                    trigger: "contacts",
                    icon: "contacts"
                },
                {
                    trigger: "messages",
                    icon: "message-text"
                },
                {
                    trigger: "camera",
                    icon: "camera"
                }
            ]
        }
    },

    computed: {
        appsPerPage() {
            return this.rows * this.appsPerRow;
        },

        battery() {
            return this.$store.getters.battery;
        }
    },

    methods: {
        toggleStatusBar() {
            this.$store.dispatch("updateStatusBar", { show: !this.$store.getters.statusBar.show });
        }
    },

    //
    // Mounted
    //
    mounted() {
        this.$root.$on("buttonPressed", button => {
            switch (button) {
                case "up":
                    this.selectedApp = this.selectedApp - appsPerRow;
                    break;
                case "right":
                    this.selectedApp++;
                    break;
                case "left":
                    this.selectedApp--;
                    break;
            }
        });

        this.$store.dispatch("updateStatusBar", {
            background: "#fafafa",
            color: "black"
        })
    }
}
</script>

<style>
.application
{
    position: relative;
    width: 95px;
    padding: 10px 0 10px 0;
    margin: 5px 0 5px 0;
    float: left;
    display: flex;
    align-items: center;
    flex-direction: column;
    justify-content: center;
    font-size: 20px;
    color: white;
    height: 75px;
    z-index: 100;
}

.application.selected .icon
{
    border: 2px solid rgba(255, 255, 255, 0.5);
    box-sizing: border-box;
}

.application p
{
    font-size: 14px;
    margin: 0;
    margin-top: 5px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: calc(100% - 10px);
}

.icon
{
    width: 55px;
    height: 55px;
    border-radius: 5px;
    font-family: 'Raleway';
    background-color: #fafafa;
    background-position: center;
    background-size: cover;
    background-repeat: no-repeat;
    display: flex;
    justify-content: center;
    align-items: center;
}

.icon .mdi
{
    color: #aaa;
}

.application.selected .icon {

    box-shadow: inset 0 0 50px rgba(0, 0, 0, 0.3);
}

.application .icon .mdi
{
    font-size: 32px;
}

#pagination
{
    display: flex;
    align-items: center;
    justify-content: center;
    bottom: 75px;
    position: absolute;
    height: 25px;
    width: 100%;
}

.page
{
    margin-left: 5px;
    margin-right: 5px;
    width: 10px;
    height: 10px;
    border-radius: 100%;
    background-color: rgba(255, 255, 255, 0.5);
}

.page.selected
{
    background-color: rgba(255, 255, 255, 0.9);
}

.menu
{
    margin-top: 35px;
}

#sticky-menu
{
    height: 65px;
    width: 100%;
    position: absolute;
    bottom: 5px;
    background-color: rgba(0, 0, 0, 0.3);
}

.sticky-app
{
    padding: 0;
    height: 65px;
    margin: 0;
}

.sticky-app .icon
{
    border-radius: 5px;
}

.sticky-app .icon .mdi
{
    color: #fff;
}

.sticky-app.selected .icon .mdi
{
    color: #fff;
}

/* Contacts */
.app-contacts .icon
{
    background-color: #1968B2;
}

.app-contacts.selected .icon
{
    background-color: #1968B2;
}


/* Messages */
.app-messages .icon
{
    background-color: #81BEF7;
}

.app-messages.selected .icon
{
    background-color: #81BEF7;
}


/* Explorer */
.app-explorer .icon
{
    background-color: #C47C18;
}

.app-explorer.selected .icon
{
    background-color: #C47C18;
}


/* Camera */
.app-camera .icon
{
    background-color: #6B6B6B;
}

.app-camera.selected .icon
{
    background-color: #6B6B6B;
}

</style>