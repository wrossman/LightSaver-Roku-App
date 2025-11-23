sub init()

    m.settingsLabel = m.top.findNode("settingsLabel")
    m.settingsLabel.width = m.global.deviceSize["w"]
    m.settingsLabel.translation = [0, m.global.deviceSize["h"] / 5]

    m.settingsSelection = m.top.findNode("settingsSelection")
    selectionX = (m.global.deviceSize["w"] - 500) / 2
    selectionY = (m.global.deviceSize["h"] - 200) / 2
    m.settingsSelection.translation = [selectionX, selectionY]
    m.settingsSelection.observeField("itemSelected", "onSettingsSelection")
    m.settingsSelection.setFocus(true)

    if m.global.resourceLinks.Count() > 0
        m.settingsContent = m.top.findNode("settingsContent")
        m.contentNodeChild = m.settingsContent.CreateChild("ContentNode")
        m.contentNodeChild.title = "Select New Google Photos Images"
    end if

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
    else if m.settingsSelection.itemSelected = 2
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "StartGooglePhotos"
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