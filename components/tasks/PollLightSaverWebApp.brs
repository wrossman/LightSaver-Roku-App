sub init()
    m.top.functionName = "pollLightSaverWebApp"
end sub

sub pollLightSaverWebApp()

    print "Start Polling LightSaver Web App"

    sessionCodeArr = {
        "SessionCode": m.global.sessionCode,
        "RokuId": m.global.clientId
    }

    jsonPostSessionBody = FormatJson(sessionCodeArr)

    post = CreateObject("roUrlTransfer")
    post.SetUrl("http://10.0.0.15:8080/roku/reception")
    postPort = CreateObject("roMessagePort")
    post.SetPort(postPort)
    responseString = ""

    while responseString <> "Ready"

        Sleep(5000)

        print "Polling Web App"
        ' needs to be updated to https once i get ssl set up
        post.AsyncPostFromString(jsonPostSessionBody)
        responseEvent = Wait(5000, postPort)

        if responseEvent <> invalid
            if responseEvent.GetString() <> ""
                responseString = responseEvent.GetString()
                print responseEvent.GetString()
            end if
        end if

        if responseString = "Expired"
            m.top.result = "expired"
            return
        end if

    end while

    print "Roku Ready to receive photos."

    m.top.result = "done"

end sub