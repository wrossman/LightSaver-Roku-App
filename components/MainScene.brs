sub init()

    m.focusTimer = CreateObject("roSGNode", "Timer")
    m.focusTimer.repeat = true
    m.focusTimer.duration = 1 ' half a second
    m.focusTimer.observeField("fire", "checkFocus")
    m.top.appendChild(m.focusTimer)
    m.focusTimer.control = "start"


    m.global.folderPath = "pkg:/images/wallpapers/"
    m.global.lightroomAlbumUrl = "470uKsm"
    m.global.picDisplayTime = 10
    m.global.backgroundColor = "#FFFFFF"
    m.global.currScreen = "Menu"
    m.top.backgroundUri = ""
    m.top.backgroundColor = m.global.backgroundColor

    m.global.observeField("currScreen", "checkScreen")
    m.global.observeField("urlChange", "changeLightroomUrl")
    m.global.observeField("displayTimeChange", "changePictureDisplayTime")

    if m.global.imageUriArr <> invalid
        for each item in m.global.imageUriArr
            print item
        end for
    end if

    checkScreen()

end sub

sub checkFocus()
    scene = m.top.getScene()
    focused = scene.focusedChild
    if focused <> invalid
        ? "Currently focused node: "; focused.id; " ("; focused.subtype(); ")"
    else
        ? "No node has focus"
    end if
end sub

sub checkScreen()
    launchScreen(m.global.currScreen)
end sub

sub launchScreen(screen as string)
    m.screen = CreateObject("roSGNode", screen)
    m.top.appendChild(m.screen)
    m.screen.setFocus(true)
end sub