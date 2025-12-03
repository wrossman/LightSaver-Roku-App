sub init()
    m.top.functionName = "getResourcePackage"
end sub

sub getResourcePackage()

    if m.global.linkSessionId = invalid or m.global.sessionCode = invalid
        m.top.result = "fail"
        return
    end if

    sessionCodeIdJson = {
        "SessionId": m.global.linkSessionId,
        "SessionCode": m.global.sessionCode
        "RokuId": m.global.clientId
    }

    postPayload = FormatJson(sessionCodeIdJson)

    post = CreateObject("roUrlTransfer")
    post.SetUrl(m.global.webappUrl + "/link/resource-package")
    postPort = CreateObject("roMessagePort")
    post.SetPort(postPort)
    post.AsyncPostFromString(postPayload)
    responseEvent = Wait(5000, postPort)

    if responseEvent = invalid
        m.top.result = "fail"
        return
    end if

    linksJsonString = responseEvent.GetString()

    if linksJsonString = invalid
        m.top.result = "fail"
        return
    end if

    linksJson = ParseJson(linksJsonString)

    if linksJson = invalid
        m.top.result = "fail"
        return
    end if

    if linksJson.Count() < 1
        m.top.result = "fail"
        return
    end if

    m.global.resourceLinks = linksJson

    m.top.result = "success"
end sub