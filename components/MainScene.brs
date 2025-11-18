sub init()

    m.global.googleClientID = "834931356217-rhe6d5j089k46p2d3rg3c1firo52971g.apps.googleusercontent.com"
    m.global.googleDiscDocUrl = "https://accounts.google.com/.well-known/openid-configuration"
    m.global.googleAuthUrl = ""
    m.global.googleImgIndex = 0
    m.global.googleUri = ""
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

    getRegistry()

    launchScreen()

end sub

sub launchScreen()
    m.screen = CreateObject("roSGNode", m.global.currScreen)
    m.top.appendChild(m.screen)
    m.screen.setFocus(true)
end sub

sub getRegistry()

    m.regConfig = CreateObject("roRegistrySection", "Config")

    if m.regConfig.Exists("albumUrl")
        m.global.lightroomAlbumUrl = m.regConfig.Read("albumUrl")
    else
        print "did not find the registry key for albumUrl"
        m.global.lightroomAlbumUrl = ""
    end if

    ' if m.regConfig.Exists("imgSource")

    '     if m.regConfig.Read("imgSource") = "google"

    '         if m.regConfig.Exists("googleLinks")
    '             m.global.imgSource = "google"
    '         else
    '             m.global.imgSource = ""
    '         end if

    '     else

    '         m.global.imgSource = m.regConfig.Read("imgSource")

    '     end if

    ' else
    '     print "did not find the registry key for imgSource"
    '     m.global.imgSource = ""
    ' end if
    m.global.imgSource = ""

end sub