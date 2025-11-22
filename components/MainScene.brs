sub init()

    m.global.googleClientID = "834931356217-rhe6d5j089k46p2d3rg3c1firo52971g.apps.googleusercontent.com"
    m.global.googleDiscDocUrl = "https://accounts.google.com/.well-known/openid-configuration"
    m.global.googleAuthUrl = ""
    m.global.filenameCounter = 0
    m.global.imgIndex = 0
    m.global.imageUri = ""
    m.global.imgSource = ""
    m.global.googlePhotosScope = "https://www.googleapis.com/auth/photospicker.mediaitems.readonly"
    m.global.certificates = "common:/certs/ca-bundle.crt"
    m.global.folderPath = "pkg:/images/wallpapers/"
    m.global.lightroomAlbumUrl = ""
    m.global.longLightroomAlbumUrl = ""
    m.global.picDisplayTime = 10
    m.global.backgroundColor = "#FFFFFF"
    m.global.currScreen = "Menu"
    m.global.settingsJumpTo = 0
    m.global.menuJumpTo = 0

    m.top.backgroundUri = ""
    m.top.backgroundColor = m.global.backgroundColor

    m.global.observeField("currScreen", "launchScreen")

    getConfig()

end sub

sub getConfig()
    m.loadConfigTask = m.top.findNode("LoadConfigTask")
    m.loadConfigTask.observeField("result", "launchScreen")
    m.loadConfigTask.control = "run"
end sub

sub launchScreen()
    m.screen = CreateObject("roSGNode", m.global.currScreen)
    m.top.appendChild(m.screen)
    m.screen.setFocus(true)
end sub
