sub init()
    m.googleLabel = m.top.findNode("googleLabel")
    m.googleLabel.width = m.global.deviceSize["w"]
    m.googleLabel.translation = [0, m.global.deviceSize["h"] / 5]

    m.getGooglePhotos = m.top.findNode("getGooglePhotos")
    m.getGooglePhotos.control = "run"

    ' m.googleSelection = m.top.findNode("googleSelection")
    ' selectionX = (m.global.deviceSize["w"] - 500) / 2
    ' selectionY = (m.global.deviceSize["h"] - 200) / 2
    ' m.googleSelection.translation = [selectionX, selectionY]
    ' m.googleSelection.observeField("itemSelected", "onGoogleSelection")
    ' m.googleSelection.setFocus(true)
end sub

sub onGoogleSelection()

    if m.googleSelection.itemSelected = 0
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "RunGoogle"
    else if m.googleSelection.itemSelected = 1
        mainScene = m.top.getParent()
        mainScene.removeChild(m.top)
        m.global.currScreen = "Menu"
    end if

end sub

sub GetPickerUri()

    'start url transfer with pem cert in cert/

end sub