
sub init()

    m.sessionCode = m.top.findNode("sessionCode")
    m.sessionCode.width = m.global.deviceSize["w"]
    m.sessionCode.translation = [0, m.global.deviceSize["h"] / 5]

    m.getSessionCodeTask = m.top.findNode("GetSessionCodeTask")
    m.getSessionCodeTask.observeField("result", "startPollTask")

    m.getGoogleResourcePackageTask = m.top.findNode("GetGoogleResourcePackageTask")
    m.pollLightSaverWebAppTask = m.top.findNode("PollLightSaverWebAppTask")

    m.getSessionCodeTask.control = "run"

end sub


sub startPollTask()
    if m.getSessionCodeTask.result = "fail"
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "WebAppError"
    end if

    m.getSessionCodeTask.unobserveField("result")
    m.sessionCode.text = m.global.sessionCode

    m.pollLightSaverWebAppTask.observeField("result", "startGetResource")
    m.pollLightSaverWebAppTask.control = "run"

end sub


sub startGetResource()

    m.pollLightSaverWebAppTask.unobserveField("result")

    m.getGoogleResourcePackageTask.observeField("result", "finishGoogleFlow")
    m.getGoogleResourcePackageTask.control = "run"

end sub

sub finishGoogleFlow()

    m.getGoogleResourcePackageTask.unobserveField("result")

    linksStr = FormatJson(m.global.googleImgLinks)

    m.settings = CreateObject("roRegistrySection", "Config")
    m.settings.Write("imgSource", "google")
    m.settings.Write("googleLinks", linksStr)
    m.settings.Flush()

    m.global.imgSource = "google"

    menu = m.top.getParent()
    menu.removeChild(m.top)
    m.global.currScreen = "GooglePhotosSuccess"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press = true

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