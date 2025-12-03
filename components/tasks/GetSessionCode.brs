sub init()
    m.top.functionName = "getSessionCode"
end sub

sub getSessionCode()

    print "in getSessionCode"

    serialArr = {
        "RokuId": m.global.clientId,
        "MaxScreenSize": m.global.maxScreenSize
    }
    serialJson = FormatJson(serialArr)

    post = CreateObject("roUrlTransfer")
    post.SetUrl(m.global.webappUrl + "/link/code")
    postPort = CreateObject("roMessagePort")
    post.SetPort(postPort)
    post.AsyncPostFromString(serialJson)
    postEvent = Wait(5000, postPort)

    postResponse = postEvent.GetString()
    sessionCodeJson = ParseJson(postResponse)

    if sessionCodeJson = invalid
        print "Unable to retrieve session code"
        m.top.result = "fail"
        'Retry for a little bit and then display that the server is down
    else
        print postResponse
        sessionCode = sessionCodeJson.LinkSessionCode
        linkSessionId = sessionCodeJson.LinkSessionId
        m.global.sessionCode = sessionCode
        m.global.linkSessionId = linkSessionId
        print "finished getting session code"
        m.top.result = "done"
    end if

end sub