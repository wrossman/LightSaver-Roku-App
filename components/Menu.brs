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
        m.wallpapers = CreateObject("roSGNode", "Wallpapers")
        m.top.appendChild(m.wallpapers)
        m.wallpapers.setFocus(true)
        m.global.wallpaperOpen = true
        m.global.observeField("wallpaperOpen", "onWallpaperClose")
    else if m.menuSelection.itemSelected = 1
        print "Goto Settings"
    end if

end sub

sub onWallpaperClose()
    m.menuSelection.setFocus(true)
    m.global.unobserveField("wallpaperOpen")
end sub