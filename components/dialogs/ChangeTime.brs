sub init()

    m.enterTime = m.top.findNode("enterTime")
    m.enterTime.font.size = 30
    m.enterTime.width = m.global.deviceSize["w"] / 2
    m.enterTime.translation = [m.global.deviceSize["w"] / 2, (m.global.deviceSize["h"] - 200) / 2 - 60]

    m.rightRect = m.top.findNode("right")
    m.rightRect.height = m.global.deviceSize["h"]
    m.rightRect.width = m.global.deviceSize["w"] / 2
    m.rightRect.translation = [m.global.deviceSize["w"] / 2, 0]

    m.pinpad = m.top.findNode("pinpad")
    selectionX = m.global.deviceSize["w"] / 2 + (m.global.deviceSize["w"] / 2 - 324) / 2
    selectionY = (m.global.deviceSize["h"] - 200) / 2
    m.pinpad.translation = [selectionX, selectionY]

end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press = true
        settings = m.top.getParent()
        settings.removeChild(m.top)
        settingsSelection = settings.findNode("settingsSelection")
        settingsSelection.setFocus(true)
        return true
    end if
    return false
end function