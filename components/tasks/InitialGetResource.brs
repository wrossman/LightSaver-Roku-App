sub init()
    m.top.functionName = "initialGet"
end sub

sub initialGet()
    print "in initial get"

    m.currHeader = {
        "Authorization": m.global.resourceLinks[m.global.keyList[0]],
        "ResourceId": m.global.keyList[0],
        "Device": m.global.clientId,
        "MaxScreenSize": m.global.maxScreenSize.ToStr()
    }

    m.imageHttp = CreateObject("roUrlTransfer")
    m.imageHttp.SetHeaders(m.currHeader)
    m.imageHttp.SetUrl(m.global.webappUrl + "/link/initial")
    m.imgHttpPort = CreateObject("roMessagePort")
    m.imageHttp.SetPort(m.imgHttpPort)
    m.imageHttp.AsyncGetToString()
    m.imgResponse = Wait(0, m.imgHttpPort)

    if m.imgResponse.GetResponseCode() < 0
        m.top.result = "fail"
        return
    end if

    m.body = m.imgResponse.GetString()

    if m.body = ""
        m.top.result = "empty"
        return
    end if

    parsedBody = ParseJson(m.body)

    if parsedBody = invalid
        m.top.result = "fail"
        return
    end if

    if parsedBody.Lookup("maxImages") <> invalid
        maxImages = parsedBody["maxImages"]
        m.top.maxImages = maxImages
        m.top.result = "overflow"
        return
    else if parsedBody.Lookup("sessionKey") <> invalid and parsedBody.Lookup("sessionId") <> invalid
        m.top.result = "update"
        m.global.lightroomUpdateKey = parsedBody["sessionKey"]
        m.global.lightroomUpdateId = parsedBody["sessionId"]
        return
    else
        m.top.result = "fail"
        return
    end if
end sub

