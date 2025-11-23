sub init()

    m.removeTempFilesTask = m.top.findNode("RemoveTempFilesTask")
    m.removeTempFilesTask.control = "run"

    m.progressDialog = CreateObject("roSGNode", "StandardProgressDialog")
    m.progressDialog.message = "Starting Wallpapers"
    m.top.appendChild(m.progressDialog)
    m.firstFire = true

    m.fadeRect = m.top.findNode("fadeRect")
    m.fadeRect.height = m.global.deviceSize["h"]
    m.fadeRect.width = m.global.deviceSize["w"]
    m.fadeRect.color = m.global.backgroundColor

    m.fadeOutAnimation = m.top.findNode("fadeOutAnimation")
    m.fadeInAnimation = m.top.findNode("fadeInAnimation")

    m.picTimer = m.top.findNode("picTimer")
    m.picTimer.duration = m.global.picDisplayTime

    m.getNextImageTask = m.top.findNode("GetNextImageTask")

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

    print m.global.imgSource

    if m.global.imgSource = "lightroom"
        m.getImageUriTask = m.top.findNode("GetImageUriTask")
        m.getImageUriTask.observeField("result", "checkLightroomUriTask")
        m.getImageUriTask.control = "run"
    else if m.global.imgSource = "google"
        m.getLinksFromRegistry = m.top.findNode("GetLinksFromRegistryTask")
        m.getLinksFromRegistry.observeField("result", "checkGoogleUriTask")
        m.getLinksFromRegistry.control = "run"
    end if
    print "end start wallpapers init"
end sub

sub onVideoState()
    print "in onvideostate"
    if m.video.state = "finished"
        print "replaying video"
        m.video.control = "play"
    end if
end sub

sub checkLightroomUriTask()
    print "in checklightroom uri task"
    m.getImageUriTask.unobserveField("result")
    if m.global.imageCount = 0
        ' Exit out of wallpaper because there are no images from lightroom task
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "LightroomImgCountError"
        return
    end if
    if m.getImageUriTask.result = "success"
        getNextImage()
    else
        ' ADD FAILURE DIALOG
        print "Get URI Task Failed with result: "m.getImageUriTask.result
    end if
end sub

sub checkGoogleUriTask()
    m.getLinksFromRegistry.unobserveField("result")
    if m.getLinksFromRegistry.result = "success"
        getNextImage()
    else
        ' ADD FAILURE DIALOG
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "SelectSource"
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
    m.getNextImageTask.observeField("result", "getPoster")
end sub

sub getPoster()
    m.getNextImageTask.unobserveField("result")

    if m.getNextImageTask.result = "401"
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppKeyError"
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
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Menu"
        return true
    end if
    return false
end function