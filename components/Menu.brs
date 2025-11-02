sub init()

    m.titleLabel = m.top.findNode("titleLabel")
    m.titleLabel.width = m.global.deviceSize["w"]

    m.menuSelection = m.top.findNode("menuSelection")
    selectionX = (m.global.deviceSize["w"] - 500) / 2
    selectionY = (m.global.deviceSize["h"] - 200) / 2
    m.menuSelection.translation = [selectionX, selectionY]
    m.menuSelection.observeField("itemSelected", "onMenuSelection")
    m.menuSelection.setFocus(true)

end sub

sub onMenuSelection()

    if m.menuSelection.itemSelected = 0
        mainScene = m.top.getParent()
        print mainScene.removeChild(m.top)
        m.global.currScreen = "wallpapers"
    else if m.menuSelection.itemSelected = 1
        mainScene = m.top.getParent()
        print mainScene.removeChild(m.top)
        m.global.currScreen = "settings"
    end if

end sub