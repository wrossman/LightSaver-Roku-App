sub init()

    m.titleLabel = m.top.findNode("titleLabel")
    m.titleLabel.width = m.global.deviceSize["w"]

    m.menuSelection = m.top.findNode("menuSelection")
    ' m.menuSelection.observeField("visible", "onSelectionVisible")
    selectionX = (m.global.deviceSize["w"] - 500) / 2
    selectionY = (m.global.deviceSize["h"] - 200) / 2
    m.menuSelection.translation = [selectionX, selectionY]
    m.menuSelection.observeField("itemSelected", "onMenuSelection")
    m.menuSelection.setFocus(true)
    ' if m.menuSelection.visible
    ' m.menuSelection.jumpToItem = m.global.menuJumpTo
    ' end if

end sub

' sub onSelectionVisible()
'     m.menuSelection.jumpToItem = m.global.menuJumpTo
' end sub


sub onMenuSelection()

    if m.menuSelection.itemSelected = 0
        ' m.global.menuJumpTo = 0
        mainScene = m.top.getParent()
        print mainScene.removeChild(m.top)
        m.global.currScreen = "Wallpapers"
    else if m.menuSelection.itemSelected = 1
        ' m.global.menuJumpTo = 1
        mainScene = m.top.getParent()
        print mainScene.removeChild(m.top)
        m.global.currScreen = "Settings"
    end if

end sub