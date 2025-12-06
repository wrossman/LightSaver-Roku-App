sub init()

    m.top.translation = [m.global.deviceSize["w"] / 2 + m.global.deviceSize["w"] / 12, 0]

    m.firstFire = true

    m.removeTempFilesTask = m.top.findNode("RemoveTempFilesTask")
    m.removeTempFilesTask.control = "run"

    m.fadeRect = m.top.findNode("fadeRect")
    m.fadeRect.height = m.global.deviceSize["h"]
    m.fadeRect.width = m.global.deviceSize["w"] / 2
    m.fadeRect.color = m.global.backgroundColor

    m.fadeOutAnimation = m.top.findNode("fadeOutAnimation")
    m.fadeInAnimation = m.top.findNode("fadeInAnimation")

    m.picTimer = m.top.findNode("picTimer")
    m.picTimer.duration = 2

    m.keyList = []
    for each item in m.global.resourceLinks
        m.keyList.Push(item)
    end for
    m.global.keyList = m.keyList

    m.getLinksFromRegistry = m.top.findNode("GetLinksFromRegistryTask")

    m.getNextImageTask = m.top.findNode("GetNextImageTask")
    m.getNextBackgroundTask = m.top.findNode("GetNextBackgroundTask")

    m.currWallpaper = m.top.findNode("currWallpaper")

    m.posterStage = CreateObject("roSGNode", "Poster")
    m.posterStage.loadDisplayMode = "scaleToFit"

    m.pollLightroomUpdateTask = m.top.findNode("PollLightroomUpdateTask")

    m.initialGetResourceTask = m.top.findNode("InitialGetResourceTask")
    m.initialGetResourceTask.observeField("result", "getLinksFromRegistry")
    m.initialGetResourceTask.control = "run"

end sub

sub getLinksFromRegistry()
    m.initialGetResourceTask.unobserveField("result")

    if m.initialGetResourceTask.result = "fail"
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "WebAppError"
        return
    else if m.initialGetResourceTask.result = "overflow"
        m.global.maxImages = m.initialGetResourceTask.maxImages
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "LightroomAlbumOverflow"
        return
    else if m.initialGetResourceTask.result = "update"
        m.pollLightroomUpdateTask.observeField("result", "checkLightroomUpdate")
        m.pollLightroomUpdateTask.control = "run"
        return
    end if

    m.getLinksFromRegistry.observeField("result", "checkUriTask")
    m.getLinksFromRegistry.control = "run"
end sub

sub checkLightroomUpdate()
    m.pollLightroomUpdateTask.unobserveField("result")

    if m.pollLightroomUpdateTask.result <> "success"
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "WebAppError"
        return
    end if

    'update the key list now that we got new links from lightroom update
    m.keyList = []
    for each item in m.global.resourceLinks
        m.keyList.Push(item)
    end for
    m.global.keyList = m.keyList

    m.getLinksFromRegistry.observeField("result", "checkUriTask")
    m.getLinksFromRegistry.control = "run"
end sub

sub checkUriTask()
    m.getLinksFromRegistry.unobserveField("result")
    if m.getLinksFromRegistry.result = "success"
        getNextImage()
    else if m.getLinksFromRegistry.result = "fail"
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "WebAppKeyError"
    end if
end sub

sub onTimerFire()
    m.picTimer.unobserveField("fire")
    m.fadeOutAnimation.control = "start"
    m.fadeOutAnimation.observeField("state", "getNextImage")
end sub

sub getNextImage()
    m.fadeOutAnimation.unobserveField("state")

    if m.global.background = "false"
        m.getNextImageTask.observeField("result", "getPoster")
    else
        m.getNextImageTask.observeField("result", "getNextBackground")
    end if

    m.getNextImageTask.control = "run"
end sub

sub getNextBackground()
    m.getNextImageTask.unobserveField("result")

    if m.getNextImageTask.result = "keyFail"
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppKeyError"
    else if m.getNextImageTask.result = "fail"
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppError"
    end if

    m.getNextBackgroundTask.observeField("result", "getPoster")
    m.getNextBackgroundTask.control = "run"

end sub

sub getPoster()

    m.getNextImageTask.unobserveField("result")

    if m.getNextImageTask.result = "keyFail"
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppKeyError"
    else if m.getNextImageTask.result = "fail"
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppError"
    end if

    m.posterStage.uri = m.global.imageUri

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

        currDevRatio = m.global.deviceSize["w"] / 3 / m.global.deviceSize["h"]

        if currPicRatio > currDevRatio
            m.currWallpaper.width = m.global.deviceSize["w"] / 3
            m.currWallpaper.height = m.global.deviceSize["w"] / 3 / currPicRatio

            moveDown = (m.global.deviceSize["h"] - m.currWallpaper.height) / 2

            m.currWallpaper.translation = [0, moveDown]
        else
            m.currWallpaper.height = m.global.deviceSize["h"]
            m.currWallpaper.width = m.global.deviceSize["h"] * currPicRatio

            moveRight = (m.global.deviceSize["w"] / 3 - m.currWallpaper.width) / 2

            m.currWallpaper.translation = [moveRight, 0]
        end if
    else
        m.currWallpaper.width = m.global.deviceSize["w"] / 3
        m.currWallpaper.height = m.global.deviceSize["h"]
        m.currWallpaper.translation = [0, 0]
    end if

    m.currWallpaper.uri = m.global.imageUri

    if m.currWallpaper.loadStatus = "loading"
        m.currWallpaper.observeField("loadStatus", "animateIn")
    else if m.currWallpaper.loadStatus = "ready"
        animateIn()
    end if

end sub

sub animateIn()
    m.currWallpaper.unobserveField("loadStatus")
    m.fadeInAnimation.control = "start"
    m.fadeInAnimation.observeField("state", "finishAnimateIn")
end sub

sub finishAnimateIn()
    m.fadeInAnimation.unobserveField("state")
    if m.firstFire
        m.firstFire = false
    end if
    if m.global.imageCount > 1
        m.picTimer.observeField("fire", "onTimerFire")
        m.picTimer.control = "start"
    end if
end sub

' function onKeyEvent(key as string, press as boolean) as boolean
'     if key = "back" and press = true
'         'remove all children of wallpapers then remove wallpaper from parent
'         if m.global.imageCount > 1
'             m.picTimer.control = "stop"
'         end if

'         'stop polling task in case it is running
'         m.pollLightroomUpdateTask.state = "stop"

'         m.global.filenameCounter++
'         m.currWallpaper.uri = ""
'         m.posterStage.uri = ""
'         m.removeTempFilesTask = m.top.findNode("RemoveTempFilesTask")
'         m.removeTempFilesTask.control = "run"

'         while m.top.getChildCount() > 0
'             m.top.removeChild(m.top.getChild(0))
'         end while
'         menu = m.top.getParent()
'         menu.removeChild(m.top)
'         m.global.currScreen = "Menu"
'         return true
'     end if
'     return false
' end function