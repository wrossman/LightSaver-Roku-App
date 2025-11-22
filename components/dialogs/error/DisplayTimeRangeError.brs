sub init()
    m.background = m.top.findNode("background")
    m.background.width = m.global.deviceSize["w"]
    m.background.height = m.global.deviceSize["h"]
    m.background.color = m.global.backgroundColor

    launchDialog()

end sub

sub launchDialog()
    m.dialog = m.top.findNode("error")
    m.dialog.title = ["Display Time Not Valid"]
    m.dialog.message = ["Please enter a number greater than 0."]
    m.dialog.buttons = ["Continue"]
    m.dialog.observeField("buttonSelected", "onButtonSelected")
end sub

sub onButtonSelected()
    m.dialog.visible = false
    if m.dialog.buttonSelected = 0
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "ChangeTime"
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press = true
        menu = m.top.getParent()
        menu.removeChild(m.top)
        m.global.currScreen = "ChangeTime"
        return true
    end if
    return false
end function