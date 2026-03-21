sub init()

    m.menuSelection = m.top.findNode("menuSelection")
    m.menuSelection.translation = [m.global.deviceSize["w"] / 12, m.global.deviceSize["h"] / 7 + 200]
    m.menuSelection.itemSize = [m.global.deviceSize["w"] / 3, m.global.deviceSize["h"] / 7]
    m.menuSelection.observeField("itemSelected", "onMenuSelection")
    m.menuSelection.setFocus(true)

end sub

sub onMenuSelection()

    if m.menuSelection.itemSelected = 0
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "StartWallpapers"
    else if m.menuSelection.itemSelected = 1
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "GetPhotos"
    else if m.menuSelection.itemSelected = 2
        m.settings = CreateObject("roSGNode", "Settings")
        m.top.appendChild(m.settings)
        m.settings.setFocus(true)
    end if

end sub