sub init()

    m.top.backgroundUri = ""
    m.top.backgroundColor = m.global.backgroundColor

    m.global.observeField("urlChange", "changeLightroomUrl")
    m.global.observeField("displayTimeChange", "changePictureDisplayTime")

end sub

sub changeLightroomUrl()
    m.currDiag = createObject("roSGNode", "UrlKeyboardDialog")
    m.currDiag.observeFieldScoped("buttonSelected", "handleUrlDialog")
    m.top.dialog = m.currDiag
    
end sub

sub changePictureDisplayTime()
end sub

sub handleUrlDialog()
    print "in handle"
    m.global.lightroomAlbumUrl = m.currDiag.text
end sub