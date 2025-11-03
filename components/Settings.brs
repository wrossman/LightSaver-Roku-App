sub init()

    m.settingsLabel = m.top.findNode("settingsLabel")
    m.settingsLabel.width = m.global.deviceSize["w"]

    m.settingsSelection = m.top.findNode("settingsSelection")
    ' m.settingsSelection.observeField("visible", "onSelectionVisible")
    selectionX = (m.global.deviceSize["w"] - 500) / 2
    selectionY = (m.global.deviceSize["h"] - 200) / 2
    m.settingsSelection.translation = [selectionX, selectionY]
    m.settingsSelection.observeField("itemSelected", "onSettingsSelection")
    m.settingsSelection.setFocus(true)
    ' if m.settingsSelection.visible
    '     m.settingsSelection.jumpToItem = m.global.settingsJumpTo
    ' end if

end sub

' sub onSelectionVisible()
'     m.settingsSelection.jumpToItem = m.global.settingsJumpTo
' end sub

sub onSettingsSelection()

    if m.settingsSelection.itemSelected = 0
        ' m.global.settingsJumpTo = 0
        mainScene = m.top.getParent()
        print mainScene.removeChild(m.top)
        m.global.currScreen = "ChangeUrl"
    else if m.settingsSelection.itemSelected = 1
        ' m.global.settingsJumpTo = 1
        mainScene = m.top.getParent()
        print mainScene.removeChild(m.top)
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