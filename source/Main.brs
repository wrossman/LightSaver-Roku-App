sub Main()

    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    scene = screen.CreateScene("MainScene")

    m.global = screen.getGlobalNode()
    m.global.AddField("deviceSize", "assocarray", true)
    m.global.AddField("resourceLinks", "assocarray", true)
    m.global.AddField("imageUriArr", "array", true)

    m.global.AddField("sessionCode", "string", true)
    m.global.AddField("folderPath", "string", true)
    m.global.AddField("currScreen", "string", true)
    m.global.AddField("backgroundColor", "string", true)
    m.global.AddField("certificates", "string", true)
    m.global.AddField("clientId", "string", true)
    m.global.AddField("imageUri", "string", true)
    m.global.AddField("loaded", "string", true)

    m.global.AddField("filenameCounter", "int", true)
    m.global.AddField("imageCount", "int", true)
    m.global.AddField("imgIndex", "int", true)
    m.global.AddField("picDisplayTime", "int", true)

    m.global.deviceSize = getDeviceSize()
    m.global.clientId = getChannelClientId()

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

function getChannelClientId()

    devInfo = CreateObject("roDeviceInfo")
    devSerial = devInfo.GetChannelClientId()

    ba = CreateObject("roByteArray")
    ba.FromAsciiString(devSerial)

    digest = CreateObject("roEVPDigest")
    digest.Setup("sha256")
    result = digest.Process(ba)

    return result

end function