sub init()
    m.background = m.top.findNode("background")
    m.background.width = m.global.deviceSize["w"]
    m.background.height = m.global.deviceSize["h"]

    m.dialog = m.top.findNode("timeKeyboard")
    m.dialog.title = "Change Picture Display Time"
    m.dialog.message = ["Please enter the time in seconds you would like each picture to be displayed."]
    m.dialog.buttons = ["OK", "Cancel"]
    m.dialog.observeField("buttonSelected", "onButtonSelected")

    ' m.keyboard = m.top.findNode("timeKeyboard")
    ' m.keyboardWidth = m.keyboard.boundingRect()["width"]
    ' m.keyboardHeight = m.keyboard.boundingRect()["height"]
    ' m.keyboardX = (m.global.deviceSize["w"] - m.keyboardWidth) / 2
    ' m.keyboardY = (m.global.deviceSize["h"] - m.keyboardHeight) / 2
    ' m.keyboard.translation = [m.keyboardX,m.keyboardY]

    ' m.okButton = m.top.findNode("okButton")
    ' m.okbuttonWidth = m.okButton.boundingRect()["width"]
    ' m.okbuttonHeight = m.okButton.boundingRect()["height"]
    ' m.okButtonX = ((m.global.deviceSize["w"] - m.okbuttonWidth) / 2) - 200
    ' ' m.okButtonY = ((m.global.deviceSize["h"] - m.okButtonHeight) / 2) - 300
    ' m.okbuttonY = m.keyboardY + m.keyboard.boundingRect()["height"] + 25
    ' m.okButton.translation = [m.okButtonX,m.okButtonY]

    ' m.cancelButton = m.top.findNode("cancelButton")
    ' m.cancelButtonWidth = m.cancelButton.boundingRect()["width"]
    ' m.cancelButtonHeight = m.cancelButton.boundingRect()["height"]
    ' m.cancelButtonX = ((m.global.deviceSize["w"] - m.cancelButtonWidth) / 2) + 200
    ' ' m.cancelButtonY = ((m.global.deviceSize["h"] - m.cancelButtonHeight) / 2) - 300
    ' m.cancelbuttonY = m.keyboardY + m.keyboard.boundingRect()["height"] + 25
    ' m.cancelButton.translation = [m.cancelButtonX,m.cancelButtonY]

end sub

sub onButtonSelected()
    if m.dialog.buttonSelected = 0
        m.global.picDisplayTime = m.dialog.text
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Settings"
    else if m.dialog.buttonSelected = 1
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "Settings"
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