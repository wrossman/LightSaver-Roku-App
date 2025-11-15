sub init()

    m.getImageUriTask = m.top.findNode("GetGooglePhotosTask")
    m.getImageUriTask.control = "run"
    m.getImageUriTask.observeField("result", "checkUriTask")

    m.progressDialog = CreateObject("roSGNode", "StandardProgressDialog")
    m.progressDialog.message = "Starting Wallpapers"
    m.top.appendChild(m.progressDialog)

    m.fadeRect = m.top.findNode("fadeRect")
    m.fadeRect.height = m.global.deviceSize["h"]
    m.fadeRect.width = m.global.deviceSize["w"]
    m.fadeRect.color = m.global.backgroundColor

    m.fadeOutAnimation = m.top.findNode("fadeOutAnimation")
    m.fadeInAnimation = m.top.findNode("fadeInAnimation")

    m.writeImgToTmpTask = m.top.findNode("WriteImgToTmp")

    m.currWallpaper = m.top.findNode("currWallpaper")

    m.posterStage = CreateObject("roSGNode", "Poster")
    m.posterStage.loadDisplayMode = "scaleToFit"

    m.global.googleImgIndex = 0

    m.videocontent = createObject("RoSGNode", "ContentNode")
    m.videocontent.streamformat = "mp4"
    m.videocontent.url = "pkg:/images/blank_5min.mp4"
    m.video = m.top.findNode("bgVideo")
    m.video.content = m.videocontent
    m.video.control = "play"

    m.video.observeField("state", "onVideoState")

end sub

sub onVideoState()
    print "in onvideostate"
    if m.video.state = "finished"
        print "replaying video"
        m.video.control = "play"
    end if
end sub


sub checkUriTask()
    if m.global.googleImgLinks.Count() > 0
        firstLaunch()
    else
        ' ADD FAILURE DIALOG
    end if
end sub

sub firstLaunch()
    m.top.removeChild(m.progressDialog)
    if m.global.googleImgLinks.Count() > 1
        m.picTimer = m.top.findNode("picTimer")
        m.picTimer.ObserveField("fire", "onTimerFire")
        m.picTimer.duration = m.global.picDisplayTime
        m.picTimer.control = "start"
    end if
    writeToTmp()
end sub

sub onTimerFire()
    m.fadeOutAnimation.control = "start"
    m.fadeOutAnimation.observeField("state", "writeToTmp")
end sub

sub writeToTmp()
    m.fadeOutAnimation.unobserveField("state")
    m.writeImgToTmpTask.control = "run"
    m.writeImgToTmpTask.observeField("result", "getPoster")

end sub

sub getPoster()
    m.writeImgToTmpTask.unobserveField("result")

    if m.writeImgToTmpTask.result = "success"
        ' ADD FAILURE DIALOG
        print "Successfully wrote file to tmp"
    else
        print "Failed to write file to tmp"
    end if

    m.posterStage.uri = m.global.googleUri

    ' m.currImageUri = m.global.imageUriArr[m.global.googleImgIndex]
    ' m.posterStage.uri = m.currImageUri

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

    m.currWallpaper.uri = m.global.googleUri

    ' m.currWallpaper.uri = m.currImageUri

    if m.currWallpaper.loadStatus = "loading"
        m.currWallpaper.observeField("loadStatus", "animateIn")
    else if m.currWallpaper.loadStatus = "ready"
        animateIn()
    end if

    m.global.googleImgIndex++
    print m.global.googleImgIndex

end sub

sub animateIn()
    m.currWallpaper.unobserveField("loadStatus")
    m.picTimer.control = "start"
    m.fadeInAnimation.control = "start"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press = true
        'remove all children of wallpapers then remove wallpaper from parent
        m.picTimer.control = "stop"
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