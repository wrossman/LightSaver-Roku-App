sub init()

    m.picTimer = m.top.findNode("picTimer")
    m.picTimer.ObserveField("fire", "onTimerFire")

    m.currWallpaper = m.top.findNode("currWallpaper")
    m.currWallpaper.loadDisplayMode = "scaleToFit"

    m.posterStage = CreateObject("roSGNode", "Poster")
    m.posterStage.loadDisplayMode = "scaleToFit"

    m.imageIndex = 0

    m.devInfo = CreateObject("roDeviceInfo")
    m.deviceSize = m.devInfo.GetDisplaySize()

    m.picTimer.control = "start"
    onTimerFire()

end sub

sub onTimerFire()

    if m.imageIndex = m.global.fileArr.Count()
        m.imageIndex = 0
    end if

    m.currImageUri = m.global.fileArr[m.imageIndex]
    m.posterStage.uri = m.currImageUri
    m.posterStage.observeField("loadStatus", "onPosterLoaded")

end sub


sub onPosterLoaded()

    m.posterStage.unobserveField("loadStatus")
    print "Current image: " + m.currImageUri
    print "bitmap width: " + m.posterStage.bitmapWidth.toStr()
    print "bitmap height: " + m.posterStage.bitmapHeight.toStr()
    if m.posterStage.loadStatus = "ready"
        print m.currImageUri + " is ready"
        currPicWidth = m.posterStage.bitmapWidth
        currPicHeight = m.posterStage.bitmapHeight
        currPicRatio = currPicWidth / currPicHeight

        currDevRatio = m.deviceSize["w"] / m.deviceSize["h"]

        if currPicRatio > currDevRatio
            m.currWallpaper.width = m.deviceSize["w"]
            m.currWallpaper.height = m.deviceSize["w"] / currPicRatio

            moveDown = (m.deviceSize["h"] - m.currWallpaper.height) / 2

            m.currWallpaper.translation = [0, moveDown]

            m.currWallpaper.uri = m.currImageUri
        else
            m.currWallpaper.height = m.deviceSize["h"]
            m.currWallpaper.width = m.deviceSize["h"] * currPicRatio

            moveRight = (m.deviceSize["w"] - m.currWallpaper.width) / 2

            m.currWallpaper.translation = [moveRight, 0]

            m.currWallpaper.uri = m.currImageUri
        end if
    else
        print m.posterStage.loadStatus + " for " + m.currImageUri
        m.currWallpaper.width = m.deviceSize["w"]
        m.currWallpaper.height = m.deviceSize["h"]
        m.currWallpaper.translation = [0, 0]
        m.currWallpaper.uri = m.currImageUri
    end if

    m.imageIndex++

end sub