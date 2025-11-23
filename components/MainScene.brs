sub init()

    m.global.filenameCounter = 0
    m.global.imgIndex = 0
    m.global.imageUri = ""
    m.global.imgSource = ""
    m.global.certificates = "common:/certs/ca-bundle.crt"
    m.global.folderPath = "pkg:/images/wallpapers/"
    m.global.lightroomAlbumUrl = ""
    m.global.longLightroomAlbumUrl = ""
    m.global.picDisplayTime = 10
    m.global.backgroundColor = "#FFFFFF"
    m.global.currScreen = "Menu"

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
