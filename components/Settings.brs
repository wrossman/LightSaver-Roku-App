sub init()

    m.settingsLabel = m.top.findNode("settingsLabel")
    m.settingsLabel.width = m.global.deviceSize["w"]

    m.settingsSelection = m.top.findNode("settingsSelection")
    selectionX = (m.global.deviceSize["w"] - 500) / 2
    selectionY = (m.global.deviceSize["h"] - 200) / 2
    m.settingsSelection.translation = [selectionX, selectionY]
    m.settingsSelection.observeField("itemSelected", "onSettingsSelection")
    m.settingsSelection.setFocus(true)

end sub

sub onSettingsSelection()

    if m.settingsSelection.itemSelected = 0
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "ChangeUrl"
    else if m.settingsSelection.itemSelected = 1
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "ChangeTime"
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