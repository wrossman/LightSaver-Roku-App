sub init()
    m.background = m.top.findNode("background")
    m.background.width = m.global.deviceSize["w"]
    m.background.height = m.global.deviceSize["h"]
    m.background.color = m.global.backgroundColor

    launchDialog()

    ' m.keyboard = m.top.findNode("urlKeyboard")
    ' m.keyboardWidth = m.keyboard.boundingRect()["width"]
    ' m.keyboardHeight = m.keyboard.boundingRect()["height"]
    ' m.keyboardX = (m.global.deviceSize["w"] - m.keyboardWidth) / 2
    ' m.keyboardY = (m.global.deviceSize["h"] - m.keyboardHeight) / 2
    ' m.keyboard.translation = [m.keyboardX, m.keyboardY]

    ' m.okButton = m.top.findNode("okButton")
    ' m.okbuttonWidth = m.okButton.boundingRect()["width"]
    ' m.okbuttonHeight = m.okButton.boundingRect()["height"]
    ' m.okButtonX = ((m.global.deviceSize["w"] - m.okbuttonWidth) / 2) - 200
    ' ' m.okButtonY = ((m.global.deviceSize["h"] - m.okButtonHeight) / 2) - 300
    ' m.okbuttonY = m.keyboardY + m.keyboard.boundingRect()["height"] + 25
    ' m.okButton.translation = [m.okButtonX, m.okButtonY]

    ' m.cancelButton = m.top.findNode("cancelButton")
    ' m.cancelButtonWidth = m.cancelButton.boundingRect()["width"]
    ' m.cancelButtonHeight = m.cancelButton.boundingRect()["height"]
    ' m.cancelButtonX = ((m.global.deviceSize["w"] - m.cancelButtonWidth) / 2) + 200
    ' ' m.cancelButtonY = ((m.global.deviceSize["h"] - m.cancelButtonHeight) / 2) - 300
    ' m.cancelbuttonY = m.keyboardY + m.keyboard.boundingRect()["height"] + 25
    ' m.cancelButton.translation = [m.cancelButtonX, m.cancelButtonY]

end sub

sub launchDialog()
    m.dialog = m.top.findNode("urlKeyboard")
    m.dialog.title = "Change Lightroom Album"
    m.dialog.message = ["Please enter the link to your public lightroom album."]
    m.dialog.buttons = ["OK", "Cancel"]
    m.dialog.observeField("buttonSelected", "onButtonSelected")
end sub

sub onButtonSelected()
    m.dialog.visible = false
    if m.dialog.buttonSelected = 0
        m.progressDialog = CreateObject("roSGNode", "StandardProgressDialog")
        m.progressDialog.message = "Changing Album"
        m.top.appendChild(m.progressDialog)
        checkNewUrl()
    else if m.dialog.buttonSelected = 1
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Settings"
    end if
end sub

sub checkNewUrl()
    m.urlBak = m.global.lightroomAlbumUrl
    m.global.lightroomAlbumUrl = m.dialog.text
    m.uriTask = CreateObject("roSGNode", "GetImageUris")
    m.top.appendChild(m.uriTask)
    m.uriTask.observeField("result", "uriTaskResultHandler")
    m.uriTask.control = "run"
end sub

sub uriTaskResultHandler()
    m.uriTask.unobserveField("result")
    m.top.removeChild(m.progressDialog)
    if m.uriTask.result = "success"
        m.settings = CreateObject("roRegistrySection", "Config")
        m.settings.Write("albumUrl", m.global.lightroomAlbumUrl)
        m.settings.Flush()
        print "wrote new album to registry"
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Settings"
    else
        m.global.lightroomAlbumUrl = m.urlBak
        print "getImageUriTask failed: " + m.uriTask.result
        m.failDialog = CreateObject("roSGNode", "StandardMessageDialog")
        m.top.appendChild(m.failDialog)
        m.failDialog.title = "Album Change Failed"
        m.failDialog.message = ["Please try again."]
        m.failDialog.buttons = ["OK"]
        m.failDialog.observeField("buttonSelected", "onFailDialogPress")
        m.failDialog.setFocus(true)

    end if

end sub

sub onFailDialogPress()
    m.top.removeChild(m.failDialog)
    if m.failDialog.buttonSelected = 0
        m.dialog.text = ""
        m.dialog.visible = true
        m.dialog.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press = true
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Settings"
        return true
    end if
    return false
end function