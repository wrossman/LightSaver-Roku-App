sub init()

    m.titleLabel = m.top.findNode("titleLabel")
    m.titleLabel.width = m.global.deviceSize["w"]
    m.titleLabel.translation = [0, m.global.deviceSize["h"] / 5]

    m.menuSelection = m.top.findNode("sourceSelection")
    selectionX = (m.global.deviceSize["w"] - 500) / 2
    selectionY = (m.global.deviceSize["h"] - 200) / 2
    m.menuSelection.translation = [selectionX, selectionY]
    m.menuSelection.observeField("itemSelected", "onMenuSelection")
    m.menuSelection.setFocus(true)

end sub

sub onMenuSelection()

    if m.menuSelection.itemSelected = 0
        ' mainScene = m.top.getParent()
        ' mainScene.removeChild(m.top)
        ' m.global.currScreen = "Wallpapers"
    else if m.menuSelection.itemSelected = 1
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "StartGooglePhotos"
    else if m.menuSelection.itemSelected = 2
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "Wallpapers"
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