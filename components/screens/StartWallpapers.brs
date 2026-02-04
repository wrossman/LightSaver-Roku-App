sub init()
    print ">> ENTER init"

    m.paused = false
    m.imageDisplayed = false

    m.solidBackground = m.top.findNode("solidBackground")
    m.solidBackground.width = m.global.deviceSize["w"]
    m.solidBackground.height = m.global.deviceSize["h"]
    m.solidBackground.opacity = 0

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

    m.idList = []
    for each item in m.global.resourceIds
        print item
        m.idList.Push(item)
    end for
    m.global.idList = m.idList

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

    m.videoContent = createObject("RoSGNode", "ContentNode")
    m.videoContent.streamFormat = "mp4"
    m.videoContent.url = "pkg:/components/data/images/blank_5min.mp4"
    m.video = m.top.findNode("bgVideo")
    m.video.content = m.videoContent
    m.video.control = "play"

    m.video.observeField("state", "onVideoState")

    m.pollLightroomUpdateTask = m.top.findNode("PollLightroomUpdateTask")

    if m.global.firstLaunch = "true"
        print "in first launch true"
        m.startFadeRect = m.top.findNode("startFadeRect")
        m.startFadeRect.opacity = 100
        m.startFadeRect.width = m.global.deviceSize["w"]
        m.startFadeRect.height = m.global.deviceSize["h"]
        m.screenFadeInAnimation = m.top.findNode("screenFadeInAnimation")
        m.screenFadeInAnimation.control = "start"
        m.screenFadeInAnimation.observeField("state", "startGetLinksFromRegistry")
    else if m.global.firstLaunch = "false"
        m.initialGetResourceTask = m.top.findNode("InitialGetResourceTask")
        m.initialGetResourceTask.observeField("result", "getLinksFromRegistry")
        m.initialGetResourceTask.control = "run"
    end if

    print "<< EXIT init"
end sub

sub startGetLinksFromRegistry()
    print ">> ENTER startGetLinksFromRegistry"

    m.screenFadeInAnimation.unobserveField("state")
    m.global.firstLaunch = "false"
    m.initialGetResourceTask = m.top.findNode("InitialGetResourceTask")
    m.initialGetResourceTask.observeField("result", "getLinksFromRegistry")
    m.initialGetResourceTask.control = "run"

    print "<< EXIT startGetLinksFromRegistry"
end sub

sub getLinksFromRegistry()
    print ">> ENTER getLinksFromRegistry"

    m.initialGetResourceTask.unobserveField("result")

    if m.initialGetResourceTask.result = "fail"
        m.top.removeChild(m.progressDialog)
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "WebAppError"
        print "<< EXIT getLinksFromRegistry"
        return
    else if m.initialGetResourceTask.result = "overflow"
        m.global.maxImages = m.initialGetResourceTask.maxImages
        m.top.removeChild(m.progressDialog)
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "LightroomAlbumOverflow"
        print "<< EXIT getLinksFromRegistry"
        return
    else if m.initialGetResourceTask.result = "update"
        m.progressDialog.message = "Retrieving new images from Lightroom Album"
        m.pollLightroomUpdateTask.observeField("result", "checkLightroomUpdate")
        m.pollLightroomUpdateTask.control = "run"
        print "<< EXIT getLinksFromRegistry"
        return
    end if

    m.getLinksFromRegistry.observeField("result", "checkUriTask")
    m.getLinksFromRegistry.control = "run"

    print "<< EXIT getLinksFromRegistry"
end sub

sub checkLightroomUpdate()
    print ">> ENTER checkLightroomUpdate"

    m.pollLightroomUpdateTask.unobserveField("result")

    if m.pollLightroomUpdateTask.result <> "success"
        m.top.removeChild(m.progressDialog)
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "WebAppError"
        print "<< EXIT checkLightroomUpdate"
        return
    end if

    'update the key list now that we got new links from lightroom update
    m.idList = []
    for each item in m.global.resourceIds
        m.idList.Push(item)
    end for
    m.global.idList = m.idList

    m.getLinksFromRegistry.observeField("result", "checkUriTask")
    m.getLinksFromRegistry.control = "run"

    print "<< EXIT checkLightroomUpdate"
end sub

sub onVideoState()
    print ">> ENTER onVideoState"

    if m.video.state = "finished"
        m.video.control = "play"
    end if

    print "<< EXIT onVideoState"
end sub

sub checkUriTask()
    print ">> ENTER checkUriTask"

    m.getLinksFromRegistry.unobserveField("result")
    if m.getLinksFromRegistry.result = "success"
        onTimerFire()
    else if m.getLinksFromRegistry.result = "fail"
        m.top.removeChild(m.progressDialog)
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "WebAppKeyError"
    end if

    print "<< EXIT checkUriTask"
end sub

sub onTimerFire()
    print ">> ENTER onTimerFire"

    m.picTimer.unobserveField("fire")

    m.imageDisplayed = false

    if m.global.background = "false"
        m.getNextImageTask.observeField("result", "getPoster")
    else
        m.getNextImageTask.observeField("result", "getNextBackground")
    end if

    m.getNextImageTask.control = "run"

    print "<< EXIT onTimerFire"
end sub

sub getNextBackground()
    print ">> ENTER getNextBackground"

    m.getNextImageTask.unobserveField("result")

    if m.getNextImageTask.result = "keyFail"
        m.top.removeChild(m.progressDialog)
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppKeyError"
        print "<< EXIT getNextBackground"
        return
    else if m.getNextImageTask.result = "fail"
        m.top.removeChild(m.progressDialog)
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppError"
        print "<< EXIT getNextBackground"
        return
    end if

    m.getNextBackgroundTask.observeField("result", "getPoster")
    m.getNextBackgroundTask.control = "run"

    print "<< EXIT getNextBackground"
end sub

sub getPoster()
    print ">> ENTER getPoster"

    m.getNextImageTask.unobserveField("result")

    if m.getNextImageTask.result = "keyFail"
        m.top.removeChild(m.progressDialog)
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppKeyError"
        print "<< EXIT getPoster"
        return
    else if m.getNextImageTask.result = "fail"
        m.top.removeChild(m.progressDialog)
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppError"
        print "<< EXIT getPoster"
        return
    end if

    m.posterStage.uri = m.global.imageUri

    if m.posterStage.loadStatus = "loading"
        m.posterStage.observeField("loadStatus", "onPosterLoaded")
    else if m.posterStage.loadStatus = "ready"
        onPosterLoaded()
    end if

    print "<< EXIT getPoster"
end sub

sub onPosterLoaded()
    print ">> ENTER onPosterLoaded"

    m.posterStage.unobserveField("loadStatus")

    m.finalWidth = 0
    m.finalHeight = 0
    m.finalTransX = 0
    m.finalTransY = 0

    if m.posterStage.loadStatus = "ready"

        currPicWidth = m.posterStage.bitmapWidth
        currPicHeight = m.posterStage.bitmapHeight
        currPicRatio = currPicWidth / currPicHeight

        currDevRatio = m.global.deviceSize["w"] / m.global.deviceSize["h"]

        if currPicRatio > currDevRatio
            m.finalWidth = m.global.deviceSize["w"]
            m.finalHeight = m.global.deviceSize["w"] / currPicRatio

            moveDown = (m.global.deviceSize["h"] - m.finalHeight) / 2

            m.finalTransY = moveDown
        else
            m.finalHeight = m.global.deviceSize["h"]
            m.finalWidth = m.global.deviceSize["h"] * currPicRatio

            moveRight = (m.global.deviceSize["w"] - m.finalWidth) / 2

            m.finalTransX = moveRight
        end if
    else
        m.finalWidth = m.global.deviceSize["w"]
        m.finalHeight = m.global.deviceSize["h"]
        m.finalTransX = 0
        m.finalTransY = 0
    end if

    if m.firstFire
        setImages()
    else
        m.fadeOutAnimation.control = "start"
        m.fadeOutAnimation.observeField("state", "setImages")
    end if

    print "<< EXIT onPosterLoaded"
end sub

sub setImages()
    print ">> ENTER setImages"

    m.fadeOutAnimation.unobserveField("state")

    m.currWallpaper.width = m.finalWidth
    m.currWallpaper.height = m.finalHeight
    m.currWallpaper.translation = [m.finalTransX, m.finalTransY]
    m.currWallpaper.uri = m.global.imageUri

    if m.global.background = "true"
        m.backgroundImg.uri = m.global.backgroundUri
    end if

    animateIn()

    print "<< EXIT setImages"
end sub

sub animateIn()
    print ">> ENTER animateIn"

    if m.firstFire
        m.top.removeChild(m.progressDialog)
        m.solidBackground.opacity = 100
    end if

    m.fadeInAnimation.control = "start"
    m.fadeInAnimation.observeField("state", "finishAnimateIn")

    print "<< EXIT animateIn"
end sub

sub finishAnimateIn()
    print ">> ENTER finishAnimateIn"

    m.fadeInAnimation.unobserveField("state")

    m.imageDisplayed = true

    if m.firstFire
        m.fadeRect.color = m.global.fadeColor
        m.firstFire = false
    end if
    if m.global.imageCount > 1 and not m.paused
        m.picTimer.observeField("fire", "onTimerFire")
        m.picTimer.control = "start"
    end if

    print "<< EXIT finishAnimateIn"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    print ">> ENTER onKeyEvent"

    if key = "OK" and press = true and m.global.imageCount > 1 and m.imageDisplayed
        ' pause the stream
        if m.paused
            print "resuming"
            m.picTimer.observeField("fire", "onTimerFire")
            m.picTimer.control = "start"
            m.paused = false
        else
            print "pausing"
            m.picTimer.unobserveField("fire")
            m.paused = true
        end if
    else if key = "left" and press = true and m.global.imageCount > 1 and m.imageDisplayed
        ' go to the last image displayed
        for i = 0 to 1
            print i
            m.global.imgIndex--
            if (m.global.imgIndex < 0)
                m.global.imgIndex = m.global.idList.Count() - 1
            end if
        end for
        m.picTimer.control = "stop"
        onTimerFire()
    else if key = "right" and press = true and m.global.imageCount > 1 and m.imageDisplayed
        ' go to the next image displayed
        m.picTimer.control = "stop"
        onTimerFire()
    else if key = "back" and press = true
        'remove all children of wallpapers then remove wallpaper from parent
        if m.global.imageCount > 1
            m.picTimer.control = "stop"
        end if

        'stop polling task in case it is running
        m.pollLightroomUpdateTask.state = "stop"

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
        print "<< EXIT onKeyEvent"
        return true
    end if

    print "<< EXIT onKeyEvent"
    return false
end function
