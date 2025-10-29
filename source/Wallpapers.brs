sub init()

    m.top.backgroundUri = ""
    m.top.backgroundColor = "#FFFFFF"

    m.currWallpaper = m.top.findNode("currWallpaper")
    m.devInfo = CreateObject("roDeviceInfo")
    m.deviceSize = m.devInfo.GetDisplaySize()

    m.posterStage = CreateObject("roSGNode", "Poster")
    m.posterStage.uri = "pkg:/images/wallpapers/disney-portrait.jpg"
    m.posterStage.observeField("loadStatus", "onPosterLoaded")

end sub

sub onPosterLoaded()

    if m.posterStage.loadStatus = "ready"
        currPicWidth = m.posterStage.bitmapWidth
        currPicHeight = m.posterStage.bitmapHeight
        currPicRatio = currPicWidth / currPicHeight

        if currPicWidth > currPicHeight
            m.currWallpaper.width = m.deviceSize["w"]
            m.currWallpaper.height = m.deviceSize["w"] / currPicRatio

            moveDown = (m.deviceSize["h"] - m.currWallpaper.height) / 2

            m.currWallpaper.translation = [0, moveDown]
        else
            m.currWallpaper.height = m.deviceSize["h"]
            m.currWallpaper.width = m.deviceSize["h"] * currPicRatio

            moveRight = (m.deviceSize["w"] - m.currWallpaper.width) / 2

            m.currWallpaper.translation = [moveRight, 0]
        end if

    end if

    m.currWallpaper.uri = "pkg:/images/wallpapers/disney-portrait.jpg"

end sub