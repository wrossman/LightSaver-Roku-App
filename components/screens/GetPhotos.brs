
sub init()

    m.fadeOutAnimation = m.top.findNode("fadeOutAnimation")
    m.fadeInAnimation = m.top.findNode("fadeInAnimation")
    m.getResourcePackageTask = m.top.findNode("GetResourcePackageTask")
    m.pollLightSaverWebAppTask = m.top.findNode("PollLightSaverWebAppTask")
    m.sessionCode = m.top.findNode("sessionCode")
    m.getSessionCodeTask = m.top.findNode("GetSessionCodeTask")
    m.title = m.top.findNode("title")
    m.directions1 = m.top.findNode("directions1")
    m.orLabel = m.top.findNode("or")
    m.navigateLabel = m.top.findNode("navigate")
    m.linkLabel = m.top.findNode("link")
    m.directions2 = m.top.findNode("directions2")
    m.screenFadeInAnimation = m.top.findNode("screenFadeInAnimation")
    m.fadeRect = m.top.findNode("fadeRect")
    m.leftRect = m.top.findNode("left")
    m.rightRect = m.top.findNode("right")
    m.fromMenuFadeIn = m.top.findNode("fromMenuFadeIn")
    m.qrCode = m.top.findNode("qrCode")
    m.fromMenuFade = m.top.findNode("fromMenuFade")


    m.leftRect.height = m.global.deviceSize["h"]
    m.leftRect.width = m.global.deviceSize["w"] / 2

    m.rightRect.height = m.global.deviceSize["h"]
    m.rightRect.width = m.global.deviceSize["w"] / 2
    m.rightRect.translation = [m.global.deviceSize["w"] / 2, 0]

    m.title.width = m.global.deviceSize["w"] / 2
    m.title.font.uri = "pkg:/components/data/fonts/" + m.global.titleFont
    m.title.font.size = 100
    m.title.translation = [0, m.global.deviceSize["h"] / 7]

    m.directions1.width = m.global.deviceSize["w"] / 2 * 3 / 4
    m.directions1.font.size = 30
    m.directions1.translation = [m.global.deviceSize["w"] / 2 / 8, m.global.deviceSize["h"] / 3 + 50]
    m.directions1.wrap = true

    m.orLabel.width = m.global.deviceSize["w"] / 2 * 3 / 4
    m.orLabel.font.size = 30
    m.orLabel.translation = [m.global.deviceSize["w"] / 2 / 8, m.global.deviceSize["h"] / 3 + 100]
    m.orLabel.wrap = true

    m.navigateLabel.width = m.global.deviceSize["w"] / 2 * 3 / 4
    m.navigateLabel.font.size = 30
    m.navigateLabel.translation = [m.global.deviceSize["w"] / 2 / 8, m.global.deviceSize["h"] / 3 + 150]
    m.navigateLabel.wrap = true

    m.linkLabel.width = m.global.deviceSize["w"] / 2 * 3 / 4
    m.linkLabel.font.size = 30
    m.linkLabel.translation = [m.global.deviceSize["w"] / 2 / 8, m.global.deviceSize["h"] / 3 + 200]
    m.linkLabel.wrap = true

    m.directions2.width = m.global.deviceSize["w"] / 2 * 3 / 4
    m.directions2.font.size = 30
    m.directions2.translation = [m.global.deviceSize["w"] / 2 / 8, m.global.deviceSize["h"] / 3 + 300]
    m.directions2.wrap = true

    m.sessionCode.width = m.global.deviceSize["w"] / 2
    m.sessionCode.translation = [m.global.deviceSize["w"] / 2, m.global.deviceSize["h"] / 5]
    m.sessionCode.font.size = 80

    m.qrCode.width = m.global.deviceSize["w"] / 2 - m.global.deviceSize["w"] / 4
    m.qrCode.height = m.global.deviceSize["w"] / 2 - m.global.deviceSize["w"] / 4
    m.qrCode.translation = [m.global.deviceSize["w"] / 2 + m.global.deviceSize["w"] / 8, m.global.deviceSize["h"] / 5 + 100]

    if m.global.firstLaunch = "true"
        print "in first launch true"
        m.fromMenuFade.opacity = 0
        m.fadeRect.opacity = 100
        m.fadeRect.width = m.global.deviceSize["w"]
        m.fadeRect.height = m.global.deviceSize["h"]
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

    menu = m.top.getParent()
    menu.removeChild(m.top)
    m.global.currScreen = ""
    m.global.currScreen = "GetPhotos"
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

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press = true

        'DONT LET THEM GO BACK IF THERE IS NOTHING LOADED
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