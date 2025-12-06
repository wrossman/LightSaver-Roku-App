sub init()

    m.enterTime = m.top.findNode("enterTime")
    m.enterTime.font.size = 30
    m.enterTime.width = m.global.deviceSize["w"] / 2
    m.enterTime.translation = [m.global.deviceSize["w"] / 2, (m.global.deviceSize["h"] - 200) / 2 - 60]

    m.pinpad = m.top.findNode("pinpad")
    selectionX = m.global.deviceSize["w"] / 2 + (m.global.deviceSize["w"] / 2 - 324) / 2
    selectionY = (m.global.deviceSize["h"] - 200) / 2
    m.pinpad.translation = [selectionX, selectionY]

end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press = true
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Settings"
        return true
    end if
    return false
end function