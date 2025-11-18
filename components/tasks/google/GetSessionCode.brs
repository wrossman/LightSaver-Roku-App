sub init()
    m.top.functionName = "getSessionCode"
end sub

sub getSessionCode()

    print "in getSessionCode"

    serialArr = {
        "RokuId": m.global.clientId
    }
    serialJson = FormatJson(serialArr)

    post = CreateObject("roUrlTransfer")
    post.SetUrl("http://10.0.0.15:8080/google/roku")
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
        sessionCode = sessionCodeJson.RokuSessionCode
        m.global.sessionCode = sessionCode
        print "finished getting session code"
        m.top.result = "done"
    end if

end sub