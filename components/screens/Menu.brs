sub init()

    m.titleLabel = m.top.findNode("titleLabel")
    m.titleLabel.width = m.global.deviceSize["w"]
    m.titleLabel.translation = [0, m.global.deviceSize["h"] / 5]

    m.menuSelection = m.top.findNode("menuSelection")
    selectionX = (m.global.deviceSize["w"] - 500) / 2
    selectionY = (m.global.deviceSize["h"] - 200) / 2
    m.menuSelection.translation = [selectionX, selectionY]
    m.menuSelection.observeField("itemSelected", "onMenuSelection")
    m.menuSelection.setFocus(true)

end sub

sub onMenuSelection()

    if m.menuSelection.itemSelected = 0
        if m.global.imgSource = ""
            mainScene = m.top.getParent()
            mainScene.removeChild(m.top)
            m.global.currScreen = "SelectSource"
        else
            mainScene = m.top.getParent()
            mainScene.removeChild(m.top)
            m.global.currScreen = "StartWallpapers"
        end if

    else if m.menuSelection.itemSelected = 1
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "ChooseImgSource"
    else if m.menuSelection.itemSelected = 2
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "Settings"
    end if

end sub