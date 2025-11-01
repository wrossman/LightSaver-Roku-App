sub init()

    m.fadeRect = m.top.findNode("fadeRect")
    ' m.fadeRect.height =

    m.fadeTimer = m.top.findNode("fadeTimer")
    m.fadeTimer.observeField("fire", "")

    m.currWallpaper = m.top.findNode("currWallpaper")
    m.currWallpaper.loadDisplayMode = "scaleToFit"

    m.posterStage = CreateObject("roSGNode", "Poster")
    m.posterStage.loadDisplayMode = "scaleToFit"

    m.imageIndex = 0

    m.picTimer = m.top.findNode("picTimer")
    m.picTimer.ObserveField("fire", "onTimerFire")
    m.picTimer.control = "start"

    onTimerFire()

end sub

sub onTimerFire()

    if m.imageIndex = m.global.imageUriArr.Count()
        m.imageIndex = 0
    end if

    m.currImageUri = m.global.imageUriArr[m.imageIndex]
    m.posterStage.uri = m.currImageUri

    if m.posterStage.loadStatus = "loading"
        m.posterStage.observeField("loadStatus", "onPosterLoaded")
    else if m.posterStage.loadStatus = "ready"
        onPosterLoaded()
    end if

end sub


sub onPosterLoaded()

    m.posterStage.unobserveField("loadStatus")

    if m.posterStage.loadStatus = "ready"

        currPicWidth = m.posterStage.bitmapWidth
        currPicHeight = m.posterStage.bitmapHeight
        currPicRatio = currPicWidth / currPicHeight

        currDevRatio = m.global.deviceSize["w"] / m.global.deviceSize["h"]

        if currPicRatio > currDevRatio
            m.currWallpaper.width = m.global.deviceSize["w"]
            m.currWallpaper.height = m.global.deviceSize["w"] / currPicRatio

            moveDown = (m.global.deviceSize["h"] - m.currWallpaper.height) / 2

            m.currWallpaper.translation = [0, moveDown]
        else
            m.currWallpaper.height = m.global.deviceSize["h"]
            m.currWallpaper.width = m.global.deviceSize["h"] * currPicRatio

            moveRight = (m.global.deviceSize["w"] - m.currWallpaper.width) / 2

            m.currWallpaper.translation = [moveRight, 0]
        end if
    else
        m.currWallpaper.width = m.global.deviceSize["w"]
        m.currWallpaper.height = m.global.deviceSize["h"]
        m.currWallpaper.translation = [0, 0]
    end if

    m.currWallpaper.uri = m.currImageUri
    m.imageIndex++

end sub