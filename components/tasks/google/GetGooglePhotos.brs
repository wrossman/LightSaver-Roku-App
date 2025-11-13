sub init()
    m.top.functionName = "pollLightSaver"
end sub

sub pollLightSaver()

    print "in get google photos"
    print m.global.certificates


    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl("http://10.0.0.15:8080/roku")
    codeResponse = urlTransfer.GetToString()
    sessionCode = Mid(codeResponse, Instr(1, codeResponse, "span id=") + 22, 6)

    print sessionCode

    sessionCodeArr = {
        "RokuSessionCode": sessionCode
    }

    jsonPostBody = FormatJson(sessionCodeArr)
    print jsonPostBody

    responseString = ""
    urlPost = CreateObject("roUrlTransfer")
    urlPost.SetUrl("http://10.0.0.15:8080/roku-reception")
    urlPostPort = CreateObject("roMessagePort")
    urlPost.SetPort(urlPostPort)

    while responseString <> "Ready"

        ' needs to be updated to https once i get ssl set up
        urlPost.AsyncPostFromString(jsonPostBody)
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

    secondPost = CreateObject("roUrlTransfer")
    secondPost.SetUrl("http://10.0.0.15:8080/roku-links")
    secondPostPort = CreateObject("roMessagePort")
    secondPost.SetPort(secondPostPort)
    secondPost.AsyncPostFromString(jsonPostBody)
    secondResponseEvent = Wait(5000, secondPostPort)

    if secondResponseEvent <> invalid
        linksJsonString = secondResponseEvent.GetString()
    end if

    if linksJsonString <> invalid
        linksJson = ParseJson(linksJsonString)
    end if

    if linksJson <> invalid
        for each link in linksJson.Links
            print link
        end for
    end if


    print "end google photos"

end sub