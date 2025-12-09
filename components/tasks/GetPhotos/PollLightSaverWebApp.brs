sub init()
    m.top.functionName = "pollLightSaverWebApp"
end sub

sub pollLightSaverWebApp()

    if m.global.linkSessionId = invalid or m.global.sessionCode = invalid
        m.top.result = "fail"
        return
    end if

    sessionCodeArr = {
        "SessionId": m.global.linkSessionId,
        "SessionCode": m.global.sessionCode,
        "RokuId": m.global.clientId
    }

    for each item in sessionCodeArr
        print item
        print sessionCodeArr[item]

    end for

    jsonPostSessionBody = FormatJson(sessionCodeArr)

    print jsonPostSessionBody

    post = CreateObject("roUrlTransfer")
    post.SetRequest("POST")
    post.AddHeader("Content-Type", "application/json")
    post.AddHeader("Accept", "application/json")
    print post.SetCertificatesFile(m.global.certificates)
    post.SetUrl(m.global.webappUrl + "/link/reception")
    postPort = CreateObject("roMessagePort")
    post.SetPort(postPort)
    post.AsyncPostFromString(jsonPostSessionBody)
    responseEvent = Wait(5000, postPort)

    if responseEvent = invalid
        m.top.result = "fail"
        return
    end if

    responseString = responseEvent.GetString()

    while responseString <> "Ready"

        Sleep(5000)

        post.AsyncPostFromString(jsonPostSessionBody)
        responseEvent = Wait(5000, postPort)

        if responseEvent = invalid
            m.top.result = "fail"
            return
        end if

        responseString = responseEvent.GetString()

        print responseString

        if responseString = "Expired"
            m.top.result = "expired"
            return
        end if
    end while

    m.top.result = "success"

end sub