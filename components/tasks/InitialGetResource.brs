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
    m.imageHttp.SetUrl("http://10.0.0.15:8080/link/initial")
    m.imgHttpPort = CreateObject("roMessagePort")
    m.imageHttp.SetPort(m.imgHttpPort)
    m.imageHttp.AsyncGetToString()
    m.imgResponse = Wait(0, m.imgHttpPort)

    if m.imgResponse.GetResponseCode() < 0
        print "initial get response code was less than 0"
        m.top.result = "failed to connect"
        return
    end if

    m.body = m.imgResponse.GetString()
    print "Response from lightsaver in initial get " + m.body.ToStr()

    if m.body = ""
        print "body was empty"
        m.top.result = "empty"
        return
    else
        print "body was not empty"

        parsedBody = ParseJson(m.body)

        if parsedBody = invalid
            return
        end if

        for each item in parsedBody
            print item
            if item = "maxImages"
                print "overflow value from body was parsed"
                maxImages = parsedBody["maxImages"]
                m.top.maxImages = maxImages
                m.top.result = "overflow"
                return
            end if
        end for

        m.top.result = "update"
        m.global.lightroomUpdateKey = parsedBody["sessionKey"]
        m.global.lightroomUpdateId = parsedBody["sessionId"]

        return
    end if
end sub

