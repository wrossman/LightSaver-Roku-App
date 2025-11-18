sub init()
    m.top.functionName = "getGoogleResourcePackage"
end sub

sub getGoogleResourcePackage()

    print "Retrieving resource package"

    sessionCodeIdJson = {
        "RokuSessionCode": m.global.sessionCode
        "RokuId": m.global.clientId
    }

    postPayload = FormatJson(sessionCodeIdJson)

    post = CreateObject("roUrlTransfer")
    post.SetUrl("http://10.0.0.15:8080/google/roku-get-resource-package")
    postPort = CreateObject("roMessagePort")
    post.SetPort(postPort)
    post.AsyncPostFromString(postPayload)
    responseEvent = Wait(5000, postPort)

    if responseEvent <> invalid
        linksJsonString = responseEvent.GetString()
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

    m.global.googleImgLinks = linksJson
    m.top.result = "done"

    print "Finished Retrieving Resource Package"

end sub