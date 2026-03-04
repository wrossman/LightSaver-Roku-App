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

    m.idList = []
    for each item in m.global.resourceIds
        m.idList.Push(item)
    end for
    m.global.idList = m.idList

    m.getLinksFromRegistry = m.top.findNode("GetLinksFromRegistryTask")

    m.getNextImageTask = m.top.findNode("GetNextImageTask")

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
        mainScene = menu.getParent()
        mainScene.removeChild(menu)
        m.global.currScreen = "WebAppError"
        return
    else if m.initialGetResourceTask.result = "overflow"
        m.global.maxImages = m.initialGetResourceTask.maxImages
        menu = m.top.getParent()
        mainScene = menu.getParent()
        mainScene.removeChild(menu)
        m.global.currScreen = "LightroomAlbumOverflow"
        return
    else if m.initialGetResourceTask.result = "update"
        m.pollLightroomUpdateTask.observeField("result", "checkLightroomUpdate")
        m.pollLightroomUpdateTask.control = "run"
        return
    else if m.initialGetResourceTask.result = "load"
        menu = m.top.getParent()
        mainScene = menu.getParent()
        mainScene.removeChild(menu)
        m.global.currScreen = "GetPhotos"
        return
    end if

    m.getLinksFromRegistry.observeField("result", "checkUriTask")
    m.getLinksFromRegistry.control = "run"
end sub

sub checkLightroomUpdate()
    m.pollLightroomUpdateTask.unobserveField("result")

    if m.pollLightroomUpdateTask.result <> "success"
        menu = m.top.getParent()
        mainScene = menu.getParent()
        mainScene.removeChild(menu)
        m.global.currScreen = "WebAppError"
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
end sub

sub checkUriTask()
    m.getLinksFromRegistry.unobserveField("result")
    if m.getLinksFromRegistry.result = "success"
        onTimerFire()
    else if m.getLinksFromRegistry.result = "fail"
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "WebAppKeyError"
    end if
end sub

sub onTimerFire()
    print ">> ENTER onTimerFire"

    m.picTimer.unobserveField("fire")

    m.getNextImageTask.observeField("result", "getPoster")
    m.getNextImageTask.control = "run"

    print "<< EXIT onTimerFire"
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
    print ">> ENTER onPosterLoaded"

    m.posterStage.unobserveField("loadStatus")

    m.finalWidth = 0
    m.finalHeight = 0
    m.finalTransX = 0
    m.finalTransY = 0

    if m.posterStage.loadStatus = "ready"

        deviceWidth = m.global.deviceSize["w"]
        deviceHeight = m.global.deviceSize["h"]

        columnWidth = deviceWidth / 3

        reducedHeight = deviceHeight * 4 / 5
        verticalOffset = deviceHeight / 10 ' 1/10 shift downward

        currPicWidth = m.posterStage.bitmapWidth
        currPicHeight = m.posterStage.bitmapHeight
        currPicRatio = currPicWidth / currPicHeight

        currDevRatio = columnWidth / reducedHeight

        if currPicRatio > currDevRatio
            m.finalWidth = columnWidth
            m.finalHeight = columnWidth / currPicRatio

            moveDown = (reducedHeight - m.finalHeight) / 2
            m.finalTransY = moveDown + verticalOffset
        else
            m.finalHeight = reducedHeight
            m.finalWidth = reducedHeight * currPicRatio

            moveRight = (columnWidth - m.finalWidth) / 2
            m.finalTransX = moveRight
            m.finalTransY = verticalOffset
        end if

    else
        m.finalWidth = m.global.deviceSize["w"] / 3
        m.finalHeight = m.global.deviceSize["h"] * 4 / 5
        m.finalTransX = 0
        m.finalTransY = m.global.deviceSize["h"] / 10
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

    animateIn()

    print "<< EXIT setImages"
end sub

sub animateIn()
    print ">> ENTER animateIn"

    m.fadeInAnimation.control = "start"
    m.fadeInAnimation.observeField("state", "finishAnimateIn")

    print "<< EXIT animateIn"
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