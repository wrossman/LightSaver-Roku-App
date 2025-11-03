sub init()
    m.background = m.top.findNode("background")
    m.background.width = m.global.deviceSize["w"]
    m.background.height = m.global.deviceSize["h"]
    
    m.keyboard = m.top.findNode("keyboard")
    m.keyboard.setFocus(true)
end sub