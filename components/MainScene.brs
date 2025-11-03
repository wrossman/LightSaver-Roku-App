sub init()

    m.global.folderPath = "pkg:/images/wallpapers/"
    m.global.lightroomAlbumUrl = "470uKsm"
    m.global.picDisplayTime = 10
    m.global.backgroundColor = "#FFFFFF"
    m.global.currScreen = "Menu"
    m.global.settingsJumpTo = 0
    m.global.menuJumpTo = 0
    m.top.backgroundUri = ""
    m.top.backgroundColor = m.global.backgroundColor

    m.global.observeField("currScreen", "checkScreen")

    if m.global.imageUriArr <> invalid
        for each item in m.global.imageUriArr
            print item
        end for
    end if

    ' m.keyboard = CreateObject("roSGNode", "DynamicKeyboard")
    ' m.top.appendChild(m.keyboard)
    ' m.keyboard.setFocus(true)

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