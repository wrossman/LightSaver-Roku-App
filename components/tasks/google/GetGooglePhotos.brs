sub init()
    m.top.functionName = "pollLightSaver"
end sub

sub pollLightSaver()

    print "in get google photos"

    serialArr = {
        "RokuId": m.global.clientId
    }
    serialJson = FormatJson(serialArr)

    firstPost = CreateObject("roUrlTransfer")
    firstPost.SetUrl("http://10.0.0.15:8080/roku")
    firstPostPort = CreateObject("roMessagePort")
    firstPost.SetPort(firstPostPort)
    firstPost.AsyncPostFromString(serialJson)
    firstPostEvent = Wait(5000, firstPostPort)

    rokuPostResponse = firstPostEvent.GetString()
    sessionCodeJson = ParseJson(rokuPostResponse)
    if sessionCodeJson = invalid
        print "Unable to retrieve session code"
        'Retry for a little bit and then display that the server is down
    end if
    sessionCode = sessionCodeJson.RokuSessionCode

    print sessionCode

    sessionCodeArr = {
        "RokuSessionCode": sessionCode
    }
    jsonPostSessionBody = FormatJson(sessionCodeArr)

    print jsonPostSessionBody

    responseString = ""
    urlPost = CreateObject("roUrlTransfer")
    urlPost.SetUrl("http://10.0.0.15:8080/roku-reception")
    urlPostPort = CreateObject("roMessagePort")
    urlPost.SetPort(urlPostPort)

    while responseString <> "Ready"

        ' needs to be updated to https once i get ssl set up
        urlPost.AsyncPostFromString(jsonPostSessionBody)
        responseEvent = Wait(5000, urlPostPort)
        if responseEvent <> invalid
            if responseEvent.GetString() <> ""
                responseString = responseEvent.GetString()
                print responseEvent.GetString()
            end if
        end if
        Sleep(5000)
    end while

    print "Ready to receive photos"

    sessionCodeIdJson = {
        "RokuSessionCode": sessionCode
        "RokuId": m.global.clientId
    }

    resourcePost = FormatJson(sessionCodeIdJson)

    secondPost = CreateObject("roUrlTransfer")
    secondPost.SetUrl("http://10.0.0.15:8080/roku-get-resource-package")
    secondPostPort = CreateObject("roMessagePort")
    secondPost.SetPort(secondPostPort)
    secondPost.AsyncPostFromString(resourcePost)
    secondResponseEvent = Wait(5000, secondPostPort)

    if secondResponseEvent <> invalid
        linksJsonString = secondResponseEvent.GetString()
    end if

    if linksJsonString <> invalid
        linksJson = ParseJson(linksJsonString)
    end if

    if linksJson <> invalid
        for each link in linksJson
            print link
            print linksJson[link]
        end for
    end if

    m.top.result = linksJson
    print "end google photos"

end sub