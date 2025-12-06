sub init()

    m.leftRect = m.top.findNode("left")
    m.rightRect = m.top.findNode("right")
    m.title = m.top.findNode("title")

    m.leftRect.height = m.global.deviceSize["h"]
    m.leftRect.width = m.global.deviceSize["w"] / 2

    m.rightRect.height = m.global.deviceSize["h"]
    m.rightRect.width = m.global.deviceSize["w"] / 2
    m.rightRect.translation = [m.global.deviceSize["w"] / 2, 0]

    m.title.width = m.global.deviceSize["w"] / 2
    m.title.font.uri = "pkg:/components/data/fonts/" + m.global.titleFont
    m.title.font.size = 100
    m.title.translation = [0, m.global.deviceSize["h"] / 7]

    m.menuSelection = m.top.findNode("menuSelection")
    m.menuSelection.translation = [m.global.deviceSize["w"] / 12, m.global.deviceSize["h"] / 7 + 200]
    m.menuSelection.itemSize = [m.global.deviceSize["w"] / 3, 70]
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
        m.global.currScreen = "Settings"
    end if

end sub