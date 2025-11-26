sub init()
    m.background = m.top.findNode("background")
    m.background.width = m.global.deviceSize["w"]
    m.background.height = m.global.deviceSize["h"]
    m.background.color = m.global.backgroundColor

    m.revokeAccess = m.top.findNode("RevokeAccess")
    m.revokeAccess.control = "run"
    m.revokeAccess.observeField("result", "finishRevokeTask")

    launchDialog()

end sub

sub launchDialog()
    m.dialog = m.top.findNode("progress")
    m.dialog.title = ["Removing Images from LightSaver"]
end sub

sub finishRevokeTask()
    if m.revokeAccess.result = "200"
        m.settings = CreateObject("roRegistrySection", "Config")
        m.settings.Write("loaded", "false")
        m.settings.Flush()
        m.global.loaded = "false"

        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "RevokeSuccess"
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press = true
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Menu"
        return true
    end if
    return false
end function