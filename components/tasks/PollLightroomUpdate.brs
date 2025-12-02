sub init()
    m.top.functionName = "pollLightroomUpdate"
end sub

sub pollLightroomUpdate()

    print "Start Polling lightroom update"

    postBody = {
        "Key": m.global.lightroomUpdateKey,
        "RokuId": m.global.clientId
    }

    jsonPostBody = FormatJson(postBody)

    post = CreateObject("roUrlTransfer")
    post.SetUrl("http://10.0.0.15:8080/link/update")
    postPort = CreateObject("roMessagePort")
    post.SetPort(postPort)
    responseString = "Media is not ready to be transfered."

    while responseString = "Media is not ready to be transfered."

        Sleep(2000)

        print "Polling Web App"
        ' needs to be updated to https once i get ssl set up
        post.AsyncPostFromString(jsonPostBody)
        responseEvent = Wait(5000, postPort)

        if responseEvent <> invalid
            if responseEvent.GetString() <> ""
                responseString = responseEvent.GetString()
            end if
        end if

        print "Response string in pollLightroomUpdate was: " + responseString

    end while

    ' print "current links"
    ' for each item in m.global.resourceLinks
    '     print item
    ' end for

    m.bodyJson = ParseJson(responseString)

    ' print "Links from response"
    ' for each item in m.bodyJson
    '     print item
    ' end for

    m.global.resourceLinks = m.bodyJson

    print "new links in m.global.resourceLinks"
    for each item in m.global.resourceLinks
        print item
    end for

    m.registry = CreateObject("roRegistrySection", "Config")
    m.registry.Write("imgLinks", FormatJson(m.bodyJson))
    m.registry.Write("loaded", "true")
    m.registry.Flush()

    m.top.result = "done"

end sub