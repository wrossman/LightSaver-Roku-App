sub init()

    m.picDisplayTime = 10

    m.fadeRect = m.top.findNode("fadeRect")
    m.fadeRect.height = m.global.deviceSize["h"]
    m.fadeRect.width = m.global.deviceSize["w"]
    m.fadeRect.color = m.global.backgroundColor

    m.fadeOutAnimation = m.top.findNode("fadeOutAnimation")
    m.fadeInAnimation = m.top.findNode("fadeInAnimation")

    m.currWallpaper = m.top.findNode("currWallpaper")

    m.posterStage = CreateObject("roSGNode", "Poster")
    m.posterStage.loadDisplayMode = "scaleToFit"

    m.imageIndex = 0

    firstLaunch()

end sub

sub firstLaunch()
    if m.global.imageUriArr.Count() > 1
        m.picTimer = m.top.findNode("picTimer")
        m.picTimer.ObserveField("fire", "onTimerFire")
        m.picTimer.duration = m.picDisplayTime
        m.picTimer.control = "start"
    end if
    getPoster()
end sub

sub onTimerFire()
    print "timer fired"
    m.fadeOutAnimation.control = "start"
    m.fadeOutAnimation.observeField("state", "getPoster")

end sub

sub getPoster()

    m.fadeOutAnimation.unobserveField("state")
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

    if m.currWallpaper.loadStatus = "loading"
        m.currWallpaper.observeField("loadStatus", "animateIn")
    else if m.currWallpaper.loadStatus = "ready"
        animateIn()
    end if

    m.imageIndex++

end sub

sub animateIn()
    m.currWallpaper.unobserveField("loadStatus")
    m.picTimer.control = "start"
    m.fadeInAnimation.control = "start"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back"
        'remove all children of wallpapers then remove wallpaper from parent
        m.picTimer.control = "stop"
        while m.top.getChildCount() > 0
            m.top.removeChild(m.top.getChild(0))
        end while
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.wallpaperOpen = false
        return true
    end if
    return false
end function