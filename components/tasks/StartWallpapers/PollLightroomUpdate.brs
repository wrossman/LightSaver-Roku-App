sub init()
    m.top.functionName = "pollLightroomUpdate"
end sub

sub pollLightroomUpdate()

    if m.global.lightroomUpdateId = invalid or m.global.lightroomUpdateKey = invalid
        m.top.result = "fail"
        return
    end if

    postBody = {
        "Id": m.global.lightroomUpdateId,
        "Key": m.global.lightroomUpdateKey,
        "RokuId": m.global.clientId
    }

    jsonPostBody = FormatJson(postBody)

    post = CreateObject("roUrlTransfer")
    print post.SetCertificatesFile(m.global.certificates)
    post.SetUrl(m.global.webappUrl + "/link/update")
    postPort = CreateObject("roMessagePort")
    post.SetPort(postPort)
    post.AsyncPostFromString(jsonPostBody)
    responseEvent = Wait(5000, postPort)

    if responseEvent = invalid
        m.top.result = "fail"
        return
    end if

    responseString = responseEvent.GetString()

    while responseString = "Media is not ready to be transferred."

        Sleep(2000)
        post.AsyncPostFromString(jsonPostBody)
        responseEvent = Wait(5000, postPort)

        if responseEvent = invalid
            m.top.result = "fail"
            return
        end if

        responseString = responseEvent.GetString()

        print "Response string in pollLightroomUpdate was: " + responseString

    end while

    m.bodyJson = ParseJson(responseString)

    if m.bodyJson = invalid or m.bodyJson.Count() < 1
        m.top.result = "fail"
        return
    end if

    m.global.resourceLinks = m.bodyJson

    m.registry = CreateObject("roRegistrySection", "Config")
    m.registry.Write("imgLinks", FormatJson(m.bodyJson))
    m.registry.Write("loaded", "true")
    m.registry.Flush()

    m.top.result = "success"

end sub