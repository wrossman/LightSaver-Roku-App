sub init()
    m.top.functionName = "getSessionCode"
end sub

sub getSessionCode()

    serialArr = {
        "RokuId": m.global.clientId,
        "MaxScreenSize": m.global.maxScreenSize
    }

    serialJson = FormatJson(serialArr)

    post = CreateObject("roUrlTransfer")
    print post.SetCertificatesFile("pkg:/components/data/certs/rootCA.crt")
    post.InitClientCertificates()
    post.SetUrl(m.global.webappUrl + "/link/code")
    postPort = CreateObject("roMessagePort")
    post.SetPort(postPort)
    post.AsyncPostFromString(serialJson)
    postEvent = Wait(5000, postPort)

    if postEvent = invalid
        m.top.result = "fail"
        return
    end if

    postResponse = postEvent.GetString()

    if postResponse = invalid
        m.top.result = "fail"
        return
    end if

    sessionCodeJson = ParseJson(postResponse)

    if sessionCodeJson = invalid
        m.top.result = "fail"
        return
    end if

    if sessionCodeJson.LinkSessionCode = invalid or sessionCodeJson.linkSessionId = invalid
        m.top.result = "fail"
        return
    end if

    m.global.sessionCode = sessionCodeJson.LinkSessionCode
    m.global.linkSessionId = sessionCodeJson.LinkSessionId

    m.top.result = "success"

end sub