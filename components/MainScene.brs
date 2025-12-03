sub init()
    getConfig()
end sub

sub getConfig()
    m.loadConfigTask = m.top.findNode("LoadConfigTask")
    m.loadConfigTask.observeField("result", "firstLaunch")
    m.loadConfigTask.control = "run"
end sub

sub firstLaunch()
    m.top.backgroundUri = ""
    m.top.backgroundColor = m.global.backgroundColor

    if m.global.loaded = "true"
        m.global.currScreen = "StartWallpapers"
    else
        m.global.currScreen = "GetPhotos"
    end if

    m.global.observeField("currScreen", "launchScreen")

    launchScreen()
end sub

sub launchScreen()
    if m.global.currScreen <> ""
        m.screen = CreateObject("roSGNode", m.global.currScreen)
        m.top.appendChild(m.screen)
        m.screen.setFocus(true)
    end if
end sub