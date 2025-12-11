sub init()
    if m.global.maxScreenSize >= 1920
        m.top.backgroundUri = "pkg:/components/data/images/splash_FHD.jpg"
    else if m.global.maxScreenSize >= 1280
        m.top.backgroundUri = "pkg:/components/data/images/splash_HD.jpg"
    else if m.global.maxScreenSize >= 720
        m.top.backgroundUri = "pkg:/components/data/images/splash_SD.jpg"
    else
        m.top.backgroundUri = ""
        m.top.backgroundColor = "#FFFFFF"
    end if

    m.top.palette = m.bluePalette

    m.loadConfigTask = m.top.findNode("LoadConfigTask")
    m.loadConfigTask.observeField("result", "startFade")
    m.loadConfigTask.observeField("palette", "setPalette")
    m.loadConfigTask.control = "run"

end sub

sub setPalette()
    m.bluePalette = CreateObject("roSGNode", "RSGPalette")
    m.bluePalette.colors = m.loadConfigTask.palette
    m.top.palette = m.bluePalette
end sub

sub startFade()
    m.loadConfigTask.unobserveField("result")

    m.fadeRect = m.top.findNode("fadeRect")
    m.fadeRect.height = m.global.deviceSize["h"]
    m.fadeRect.width = m.global.deviceSize["w"]

    m.fadeOutAnimation = m.top.findNode("fadeOutAnimation")
    m.fadeOutAnimation.control = "start"
    m.fadeOutAnimation.observeField("state", "firstLaunch")
end sub

sub firstLaunch()
    m.fadeOutAnimation.unobserveField("state")

    if m.global.loaded = "true"
        m.global.currScreen = "StartWallpapers"
    else
        m.global.currScreen = "GetPhotos"
    end if

    m.global.observeField("currScreen", "launchScreen")

    launchScreen()
    m.top.backgroundUri = ""
    m.top.backgroundColor = "#FFFFFF"
end sub

sub launchScreen()
    if m.global.currScreen <> ""
        m.screen = CreateObject("roSGNode", m.global.currScreen)
        m.top.appendChild(m.screen)
        m.screen.setFocus(true)
    end if
end sub