sub init()

    m.focusTimer = CreateObject("roSGNode", "Timer")
    m.focusTimer.repeat = true
    m.focusTimer.duration = 1   ' half a second
    m.focusTimer.observeField("fire", "checkFocus")
    m.top.appendChild(m.focusTimer)
    m.focusTimer.control = "start"


    m.global.folderPath = "pkg:/images/wallpapers/"
    m.global.lightroomAlbumUrl = "470uKsm"
    m.global.picDisplayTime = 10
    m.global.backgroundColor = "#FFFFFF"
    m.global.currScreen = "menu"
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

sub checkScreen()
    if m.global.currScreen = "menu"
        launchMenu()
    else if m.global.currScreen = "settings"
        launchSettings()
    else if m.global.currScreen = "wallpapers"
        launchWallpapers()
    else
        print "Screen not found"
    end if

end sub

sub launchMenu()
    m.menu = CreateObject("roSGNode", "Menu")
    m.top.appendChild(m.menu)
    m.menu.setFocus(true)
end sub

sub launchSettings()
    m.settings = CreateObject("roSGNode", "Settings")
    m.top.appendChild(m.settings)
    m.settings.setFocus(true)
end sub

sub launchWallpapers()
    getImageUris()
    m.wallpapers = CreateObject("roSGNode", "Wallpapers")
    m.top.appendChild(m.wallpapers)
    m.wallpapers.setFocus(true)
end sub

sub launchChangeUrl()
    getImageUris()
    m.wallpapers = CreateObject("roSGNode", "Wallpapers")
    m.top.appendChild(m.wallpapers)
    m.wallpapers.setFocus(true)
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

sub changeLightroomUrl()
    m.currDiag = createObject("roSGNode", "UrlKeyboardDialog")
    m.currDiag.observeFieldScoped("buttonSelected", "handleUrlDialog")
    m.top.dialog = m.currDiag

end sub

sub changePictureDisplayTime()
    ' m.currDiag = createObject("roSGNode", "TimeKeyboardDialog")
    ' m.currDiag.observeFieldScoped("buttonSelected", "handleTimeDialog")
    ' m.top.dialog = m.currDiag
    m.changeTime = CreateObject("roSGNode","ChangeTime")
    m.top.appendChild(m.changeTime)
    
end sub

sub handleUrlDialog()
    print "in handle url"
    print m.currDiag.text
    if m.currDiag.buttonSelected = "OK"
        m.global.observeField("lightroomAlbumUrl", "getImageUris")
        m.global.lightroomAlbumUrl = m.currDiag.text
    else if m.currDiag.buttonSelected = "Cancel"
        'add closing logic
        print "close dialog"
    end if
end sub

sub handleTimeDialog()
    print "in handle time"
    print m.currDiag.text
    if m.currDiag.buttonSelected = 0
        m.global.picDisplayTime = m.currDiag.text
    else if m.currDiag.buttonSelected = 1
        'add closing logic
        print "close dialog"
    end if
end sub

sub getImageUris()
    m.global.unobserveField("lightroomAlbumUrl")
    m.getImageUriTask = CreateObject("roSGNode", "GetImageUris")
    m.getImageUriTask.control = "run"
end sub