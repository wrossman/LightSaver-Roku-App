
sub init()

    m.fadeOutAnimation = m.top.findNode("fadeOutAnimation")
    m.fadeInAnimation = m.top.findNode("fadeInAnimation")

    m.sessionCode = m.top.findNode("sessionCode")
    m.sessionCode.width = m.global.deviceSize["w"]
    m.sessionCode.translation = [0, m.global.deviceSize["h"] / 5]

    m.getSessionCodeTask = m.top.findNode("GetSessionCodeTask")
    m.getSessionCodeTask.observeField("result", "startSessionCheck")

    m.getResourcePackageTask = m.top.findNode("GetResourcePackageTask")
    m.pollLightSaverWebAppTask = m.top.findNode("PollLightSaverWebAppTask")

    m.getSessionCodeTask.control = "run"

end sub


sub startSessionCheck()
    if m.getSessionCodeTask.result = "fail"
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppError"
    end if

    m.getSessionCodeTask.unobserveField("result")
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
        print "Recieved expired"
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

    linksStr = FormatJson(m.global.resourceLinks)

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
        if m.global.loaded = "false"
            return true
        end if
        if m.pollLightSaverWebAppTask.state <> "done"
            m.pollLightSaverWebAppTask.control = "stop"
        end if

        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Settings"
        return true
    end if
    return false
end function