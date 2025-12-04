sub init()
    m.background = m.top.findNode("background")
    m.background.width = m.global.deviceSize["w"]
    m.background.height = m.global.deviceSize["h"]

    m.pinpad = m.top.findNode("pinpad")
    selectionX = (m.global.deviceSize["w"] - 324) / 2
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