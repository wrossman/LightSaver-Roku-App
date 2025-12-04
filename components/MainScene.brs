sub init()
    getConfig()

    m.bluePalette = CreateObject("roSGNode", "RSGPalette")
    m.bluePalette.colors = {
        DialogBackgroundColor: "0xF0F0F0FF", ' inverted: dark navy → soft white
        DialogItemColor: "0x001F3FFF", ' inverted: white → favorite blue
        DialogTextColor: "0x001F3FFF", ' inverted: white → favorite blue

        DialogFocusColor: "0x001A36FF", ' inverted: soft white → soft blue
        DialogFocusItemColor: "0xFFFFFFFF", ' inverted: your blue → white

        DialogSecondaryTextColor: "0x001F3FFF", ' inverted: white → favorite blue
        DialogSecondaryItemColor: "0x001F3F66", ' inverted: semi white → semi blue

        DialogInputFieldColor: "0x001A36FF", ' inverted: soft white → soft blue
        DialogKeyboardColor: "0x001F3FFF", ' inverted: white → favorite blue
        DialogFootprintColor: "0x001F3F80" ' inverted: semi white → semi blue
    }

    m.top.palette = m.bluePalette

end sub

sub getConfig()
    m.loadConfigTask = m.top.findNode("LoadConfigTask")
    m.loadConfigTask.observeField("result", "firstLaunch")
    m.loadConfigTask.control = "run"
end sub

sub firstLaunch()
    m.top.backgroundUri = ""
    m.top.backgroundColor = m.global.backgroundColor

    if m.global.loaded = "true"
        m.global.currScreen = "StartWallpapers"
    else
        m.global.currScreen = "GetPhotos"
    end if

    m.global.observeField("currScreen", "launchScreen")

    launchScreen()
end sub

sub launchScreen()
    if m.global.currScreen <> ""
        m.screen = CreateObject("roSGNode", m.global.currScreen)
        m.top.appendChild(m.screen)
        m.screen.setFocus(true)
    end if
end sub