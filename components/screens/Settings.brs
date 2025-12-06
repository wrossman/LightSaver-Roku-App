sub init()

    m.leftRect = m.top.findNode("left")
    m.title = m.top.findNode("title")

    m.leftRect.height = m.global.deviceSize["h"]
    m.leftRect.width = m.global.deviceSize["w"] / 2

    m.title.width = m.global.deviceSize["w"] / 2
    m.title.font.uri = "pkg:/components/data/fonts/" + m.global.titleFont
    m.title.font.size = 100
    m.title.translation = [0, m.global.deviceSize["h"] / 7]

    m.settingsSelection = m.top.findNode("settingsSelection")
    m.settingsSelection.translation = [m.global.deviceSize["w"] / 12, m.global.deviceSize["h"] / 7 + 200]
    m.settingsSelection.itemSize = [m.global.deviceSize["w"] / 3, 70]
    m.settingsSelection.observeField("itemSelected", "onSettingsSelection")
    m.settingsSelection.setFocus(true)

    m.blurredSetting = m.top.findNode("blurred")
    if m.global.background = "true"
        m.blurredSetting.title = "Disable Blurred Image Background"
    else
        m.blurredSetting.title = "Enable Blurred Image Background"
    end if

end sub

sub onSettingsSelection()

    if m.settingsSelection.itemSelected = 0
        m.changeTime = CreateObject("roSGNode", "ChangeTime")
        m.top.appendChild(m.changeTime)
        m.changeTime.setFocus(true)
    else if m.settingsSelection.itemSelected = 1

        m.registry = CreateObject("roRegistrySection", "Config")

        if m.global.background = "true"
            m.global.background = "false"
            m.registry.Write("background", "false")
            m.blurredSetting.title = "Enable Blurred Image Background"
        else
            m.global.background = "true"
            m.registry.Write("background", "true")
            m.blurredSetting.title = "Disable Blurred Image Background"
        end if

    else if m.settingsSelection.itemSelected = 2
        menu = m.top.getParent()
        mainScene = menu.getParent()
        mainScene.removeChild(menu)
        m.global.currScreen = "RevokeAccessSuccess"
    end if

end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press = true
        menu = m.top.getParent()
        menu.removeChild(m.top)
        menuSelection = menu.findNode("menuSelection")
        menuSelection.setFocus(true)
        return true
    end if
    return false
end function