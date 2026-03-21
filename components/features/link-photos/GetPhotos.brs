sub init()

    m.fadeOutAnimation = m.top.findNode("fadeOutAnimation")
    m.fadeInAnimation = m.top.findNode("fadeInAnimation")
    m.getResourcePackageTask = m.top.findNode("GetResourcePackageTask")
    m.pollLightSaverWebAppTask = m.top.findNode("PollLightSaverWebAppTask")
    m.sessionCode = m.top.findNode("sessionCode")
    m.getSessionCodeTask = m.top.findNode("GetSessionCodeTask")
    m.title = m.top.findNode("title")
    m.directions1 = m.top.findNode("directions1")
    m.linkLabel = m.top.findNode("link")
    m.directions2 = m.top.findNode("directions2")
    m.screenFadeInAnimation = m.top.findNode("screenFadeInAnimation")
    m.fadeRect = m.top.findNode("fadeRect")
    m.leftRect = m.top.findNode("left")
    m.rightRect = m.top.findNode("right")
    m.fromMenuFadeIn = m.top.findNode("fromMenuFadeIn")
    m.qrCode = m.top.findNode("qrCode")
    m.fromMenuFade = m.top.findNode("fromMenuFade")
    m.downloadDialog = m.top.findNode("downloadDialog")
    m.downloadBackground = m.top.findNode("downloadBackground")

    m.downloadBackground.height = m.global.deviceSize["h"]
    m.downloadBackground.width = m.global.deviceSize["w"]

    m.downloadDialog.width = m.downloadDialog.boundingRect().width

    m.leftRect.height = m.global.deviceSize["h"]
    m.leftRect.width = m.global.deviceSize["w"] / 2

    m.rightRect.height = m.global.deviceSize["h"]
    m.rightRect.width = m.global.deviceSize["w"] / 2
    m.rightRect.translation = [m.global.deviceSize["w"] / 2, 0]

    m.title.width = m.global.deviceSize["w"] / 2
    m.title.font.uri = "pkg:/components/data/fonts/" + m.global.titleFont
    m.title.font.size = 100
    m.title.translation = [0, m.global.deviceSize["h"] / 2 - (m.title.boundingRect().height / 2)]

    ' ---- RIGHT SIDE (VERTICALLY JUSTIFIED WITH 1/8 TOP/BOTTOM PADDING) ----
    w = m.global.deviceSize["w"]
    h = m.global.deviceSize["h"]

    rightX = w / 2
    rightW = w / 2

    topPadding = h / 8
    bottomPadding = h / 8
    usableHeight = h - topPadding - bottomPadding

    ' ---- Widths + fonts (must be set before measuring) ----
    m.directions1.width = rightW
    m.directions1.font.size = 25
    m.directions1.wrap = true

    m.linkLabel.width = rightW
    m.linkLabel.font.size = 35
    m.linkLabel.wrap = true

    m.directions2.width = rightW
    m.directions2.font.size = 25
    m.directions2.wrap = true

    m.sessionCode.width = rightW
    m.sessionCode.font.size = 80

    ' ---- QR sizing ----
    qrSize = rightW / 2
    m.qrCode.width = qrSize
    m.qrCode.height = qrSize
    m.qrCodeHeight = qrSize

    qrX = rightX + (rightW - qrSize) / 2

    ' ---- Measure heights ----
    h1 = m.directions1.boundingRect().height
    h2 = m.linkLabel.boundingRect().height
    h3 = m.qrCode.height
    h4 = m.directions2.boundingRect().height
    h5 = m.sessionCode.boundingRect().height

    totalContentHeight = h1 + h2 + h3 + h4 + h5

    ' 5 items → 4 internal gaps
    gap = (usableHeight - totalContentHeight) / 4
    if gap < 10 then gap = 10

    ' ---- Start at padded top ----
    y = topPadding

    m.directions1.translation = [rightX, y]
    y += h1 + gap

    m.linkLabel.translation = [rightX, y]
    y += h2 + gap

    m.qrCode.translation = [qrX, y]
    y += h3 + gap

    m.directions2.translation = [rightX, y]
    y += h4 + gap

    m.sessionCode.translation = [rightX, y]

    m.pollLightSaverWebAppTask.observeField("resourceCount", "showDownloadDialog")

    if m.global.firstLaunch = "true"
        print "in first launch true"
        m.fromMenuFade.opacity = 0
        m.fadeRect.opacity = 100
        m.screenFadeInAnimation.control = "start"
        m.screenFadeInAnimation.observeField("state", "startGetSessionCodeTask")
    else if m.global.firstLaunch = "false"
        m.fromMenuFadeIn.control = "start"
        m.fromMenuFadeIn.observeField("state", "startGetSessionCodeTask")
    end if

end sub

sub startGetSessionCodeTask()
    m.fromMenuFadeIn.unobserveField("state")
    m.screenFadeInAnimation.unobserveField("state")
    m.global.firstLaunch = "false"
    m.getSessionCodeTask.observeField("result", "startSessionCheck")
    m.getSessionCodeTask.control = "run"
end sub

sub startSessionCheck()
    print "in start session check"
    m.getSessionCodeTask.unobserveField("result")

    if m.getSessionCodeTask.result = "fail"
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppError"
        return
    end if

    m.sessionCode.text = m.global.sessionCode

    m.fadeInAnimation.control = "start"
    m.fadeInAnimation.observeField("state", "startPollTask")
end sub

sub startPollTask()
    m.fadeInAnimation.unobserveField("state")

    m.pollLightSaverWebAppTask.observeField("result", "startGetResource")
    m.pollLightSaverWebAppTask.control = "run"
end sub


sub startGetResource()
    m.pollLightSaverWebAppTask.unobserveField("result")

    if m.pollLightSaverWebAppTask.result = "expired"
        m.fadeOutAnimation.control = "start"
        m.fadeOutAnimation.observeField("state", "animateOutFinished")
        return
    else if m.pollLightSaverWebAppTask.result = "fail"
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppError"
        return
    end if

    m.getResourcePackageTask.observeField("result", "finishGetPhotosFlow")
    m.getResourcePackageTask.control = "run"
end sub

sub animateOutFinished()
    m.fadeOutAnimation.unobserveField("state")

    m.top.removeChild(m.getSessionCodeTask)
    m.top.removeChild(m.getResourcePackageTask)
    m.top.removeChild(m.pollLightSaverWebAppTask)

    m.getSessionCodeTask = CreateObject("roSGNode", "GetSessionCode")
    m.pollLightSaverWebAppTask = CreateObject("roSGNode", "PollLightSaverWebApp")
    m.pollLightSaverWebAppTask.observeField("resourceCount", "showDownloadDialog")

    m.top.appendChild(m.getSessionCodeTask)
    m.top.appendChild(m.pollLightSaverWebAppTask)

    startGetSessionCodeTask()

end sub

sub finishGetPhotosFlow()
    m.getResourcePackageTask.unobserveField("result")

    if m.getResourcePackageTask.result = "fail"
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "WebAppError"
        return
    end if

    linksStr = FormatJson(m.global.resourceIds)

    m.settings = CreateObject("roRegistrySection", "Config")
    m.settings.Write("imgLinks", linksStr)
    m.settings.Write("loaded", "true")
    m.settings.Flush()

    m.global.loaded = "true"

    menu = m.top.getParent()
    menu.removeChild(m.top)
    m.global.currScreen = "GetPhotosSuccess"
end sub

sub showDownloadDialog()
    m.downloadBackground.visible = true
    m.downloadDialog.visible = true
    if m.pollLightSaverWebAppTask.resourceCount = 1
        m.downloadDialog.message = "Uploaded " + m.pollLightSaverWebAppTask.resourceCount.ToStr() + " image to LightSaver..."
    else
        m.downloadDialog.message = "Uploaded " + m.pollLightSaverWebAppTask.resourceCount.ToStr() + " images to LightSaver..."
    end if

end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press = true

        if m.pollLightSaverWebAppTask.resourceCount > 0
            return true
        end if

        if m.global.loaded = "false"
            return true
        end if

        if m.pollLightSaverWebAppTask.state <> "done"
            m.pollLightSaverWebAppTask.control = "stop"
        end if

        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Menu"
        return true
    end if
    return false
end function