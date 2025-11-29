sub init()
    m.progressDialog = CreateObject("roSGNode", "StandardProgressDialog")
    m.progressDialog.message = "Starting Wallpapers"
    m.top.appendChild(m.progressDialog)
    m.firstFire = true

    m.removeTempFilesTask = m.top.findNode("RemoveTempFilesTask")
    m.removeTempFilesTask.control = "run"

    m.fadeRect = m.top.findNode("fadeRect")
    m.fadeRect.height = m.global.deviceSize["h"]
    m.fadeRect.width = m.global.deviceSize["w"]
    m.fadeRect.color = m.global.backgroundColor

    m.fadeOutAnimation = m.top.findNode("fadeOutAnimation")
    m.fadeInAnimation = m.top.findNode("fadeInAnimation")

    m.picTimer = m.top.findNode("picTimer")
    m.picTimer.duration = m.global.picDisplayTime

    m.keyList = []
    for each item in m.global.resourceLinks
        m.keyList.Push(item)
    end for
    m.global.keyList = m.keyList

    m.getLinksFromRegistry = m.top.findNode("GetLinksFromRegistryTask")

    m.getNextImageTask = m.top.findNode("GetNextImageTask")
    m.getNextBackgroundTask = m.top.findNode("GetNextBackgroundTask")

    m.backgroundImg = m.top.findNode("backgroundImg")
    if m.global.background = "false"
        m.backgroundImg.opacity = 0.0
    else
        m.backgroundImg.opacity = 1.0
    end if

    m.currWallpaper = m.top.findNode("currWallpaper")

    m.posterStage = CreateObject("roSGNode", "Poster")
    m.posterStage.loadDisplayMode = "scaleToFit"

    m.videocontent = createObject("RoSGNode", "ContentNode")
    m.videocontent.streamformat = "mp4"
    m.videocontent.url = "pkg:/images/blank_5min.mp4"
    m.video = m.top.findNode("bgVideo")
    m.video.content = m.videocontent
    m.video.control = "play"

    m.video.observeField("state", "onVideoState")

    m.pollLightroomUpdateTask = m.top.findNode("PollLightroomUpdateTask")

    m.initialGetResourceTask = m.top.findNode("InitialGetResourceTask")
    m.initialGetResourceTask.observeField("result", "getLinksFromRegistry")
    m.initialGetResourceTask.control = "run"

    print "end start wallpapers init"
end sub

sub getLinksFromRegistry()
    m.initialGetResourceTask.unobserveField("result")

    if m.initialGetResourceTask.result = "failed to connect"
        m.top.removeChild(m.progressDialog)
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "WebAppError"
    else if m.initialGetResourceTask.result = "update"
        m.progressDialog.message = "Retrieving new images from Lightroom Album"
        m.pollLightroomUpdateTask.observeField("result", "checkLightroomUpdate")
        m.pollLightroomUpdateTask.control = "run"
        return
    end if

    m.getLinksFromRegistry.observeField("result", "checkUriTask")
    m.getLinksFromRegistry.control = "run"
end sub

sub checkLightroomUpdate()
    m.pollLightroomUpdateTask.unobserveField("result")

    m.keyList = []
    for each item in m.global.resourceLinks
        m.keyList.Push(item)
    end for
    m.global.keyList = m.keyList

    m.getLinksFromRegistry.observeField("result", "checkUriTask")
    m.getLinksFromRegistry.control = "run"
end sub

sub onVideoState()
    print "in onvideostate"
    if m.video.state = "finished"
        print "replaying video"
        m.video.control = "play"
    end if
end sub

sub checkUriTask()
    m.getLinksFromRegistry.unobserveField("result")
    if m.getLinksFromRegistry.result = "success"
        getNextImage()
    else
        ' ADD FAILURE DIALOG
        m.top.removeChild(m.progressDialog)
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Menu"
        print "Get URI Task Failed with result: "m.getLinksFromRegistry.result
    end if
end sub

sub onTimerFire()
    m.picTimer.unobserveField("fire")
    m.fadeOutAnimation.control = "start"
    m.fadeOutAnimation.observeField("state", "getNextImage")
end sub

sub getNextImage()
    m.fadeOutAnimation.unobserveField("state")
    m.getNextImageTask.control = "run"
    if m.global.background = "false"
        m.getNextImageTask.observeField("result", "getPoster")
    else
        m.getNextImageTask.observeField("result", "getNextBackground")
    end if
end sub

sub getNextBackground()
    m.getNextImageTask.unobserveField("result")

    m.getNextBackgroundTask.observeField("result", "getPoster")
    m.getNextBackgroundTask.control = "run"

end sub

sub getPoster()

    if m.global.background = "false"
        m.getNextImageTask.unobserveField("result")
    else
        m.getNextBackgroundTask.unobserveField("result")
        if m.getNextBackgroundTask.result <> "fail" and m.getNextBackgroundTask.result <> "401"
            m.backgroundImg.uri = m.global.backgroundUri
        end if
    end if


    if m.getNextImageTask.result = "401"
        m.top.removeChild(m.progressDialog)
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppKeyError"
    else if m.getNextImageTask.result = "fail"
        m.top.removeChild(m.progressDialog)
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppError"
    end if

    print "setting posterstage uri to " + m.global.imageUri
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
    print "setting currwallpaper uri to " + m.global.imageUri
    m.currWallpaper.uri = m.global.imageUri

    if m.currWallpaper.loadStatus = "loading"
        m.currWallpaper.observeField("loadStatus", "animateIn")
    else if m.currWallpaper.loadStatus = "ready"
        animateIn()
    end if

end sub

sub animateIn()
    if m.firstFire
        m.top.removeChild(m.progressDialog)
        m.firstFire = false
    end if
    m.currWallpaper.unobserveField("loadStatus")
    m.fadeInAnimation.control = "start"
    m.fadeInAnimation.observeField("state", "finishAnimateIn")
end sub

sub finishAnimateIn()
    m.fadeInAnimation.unobserveField("state")
    if m.global.imageCount > 1
        m.picTimer.observeField("fire", "onTimerFire")
        m.picTimer.control = "start"
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press = true
        'remove all children of wallpapers then remove wallpaper from parent
        if m.global.imageCount > 1
            m.picTimer.control = "stop"
        end if

        m.global.filenameCounter++
        m.currWallpaper.uri = ""
        m.posterStage.uri = ""
        m.removeTempFilesTask = m.top.findNode("RemoveTempFilesTask")
        m.removeTempFilesTask.control = "run"

        while m.top.getChildCount() > 0
            m.top.removeChild(m.top.getChild(0))
        end while
        m.top.removeChild(m.progressDialog)
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Menu"
        return true
    end if
    return false
end function