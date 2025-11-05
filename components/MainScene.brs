sub init()

    m.global.folderPath = "pkg:/images/wallpapers/"
    m.global.lightroomAlbumUrl = ""
    ' m.global.lightroomAlbumUrl = "a"
    m.global.longLightroomAlbumUrl = ""
    m.global.picDisplayTime = 10
    m.global.backgroundColor = "#FFFFFF"
    m.global.currScreen = "Menu"
    m.global.settingsJumpTo = 0
    m.global.menuJumpTo = 0
    m.top.backgroundUri = ""
    m.top.backgroundColor = m.global.backgroundColor

    getRegistry()
    
    m.global.observeField("currScreen", "checkScreen")

    if m.global.imageUriArr <> invalid
        for each item in m.global.imageUriArr
            print item
        end for
    end if

    checkScreen()

end sub

sub checkScreen()
    launchScreen(m.global.currScreen)
end sub

sub launchScreen(screen as string)
    m.screen = CreateObject("roSGNode", screen)
    m.top.appendChild(m.screen)
    m.screen.setFocus(true)
end sub

sub getRegistry()

    m.settings  = CreateObject("roRegistrySection", "Config")
    if m.settings.Exists("albumUrl")
        print "found registry"
        m.global.lightroomAlbumUrl = m.settings.Read("albumUrl")
        print m.settings.Read("albumUrl")
    else
        print "did not find the registry key"
    end if

end sub