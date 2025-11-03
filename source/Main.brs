sub Main()

    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    scene = screen.CreateScene("MainScene")

    m.global = screen.getGlobalNode()
    m.global.AddField("deviceSize", "assocarray", true)
    m.global.AddField("imageUriArr", "array", true)
    m.global.AddField("folderPath", "string", true)
    m.global.AddField("currScreen", "string", true)
    m.global.AddField("backgroundColor", "string", true)
    m.global.AddField("lightroomAlbumUrl", "string", true)
    m.global.AddField("picDisplayTime", "int", true)
    m.global.AddField("settingsJumpTo", "int", true)
    m.global.AddField("menuJumpTo", "int", true)

    m.global.deviceSize = getDeviceSize()

    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub


function getDeviceSize()
    devInfo = CreateObject("roDeviceInfo")
    return devInfo.GetDisplaySize()
end function