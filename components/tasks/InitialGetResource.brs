sub init()
    m.top.functionName = "initialGet"
end sub

sub initialGet()

    ' this can be sent to a global variable so it doesnt run everytime
    m.keyList = []

    for each item in m.global.resourceLinks
        m.keyList.Push(item)
        exit for
    end for

    m.currHeader = {
        "Authorization": m.global.resourceLinks[m.keyList[0]],
        "Location": m.keyList[0],
        "Device": m.global.clientId,
        "MaxScreenSize": m.global.maxScreenSize.ToStr()
    }

    m.imageHttp = CreateObject("roUrlTransfer")
    m.imageHttp.SetHeaders(m.currHeader)
    m.imageHttp.SetUrl("http://10.0.0.15:8080/roku/initial")
    m.imgHttpPort = CreateObject("roMessagePort")
    m.imageHttp.SetPort(m.imgHttpPort)
    m.imageHttp.AsyncGetToString()
    m.imgResponse = Wait(0, m.imgHttpPort)

    if m.imgResponse.GetResponseCode() < 0
        m.top.result = "failed to connect"
        return
    end if

    m.body = m.imgResponse.GetString()
    print m.body
    if m.body = ""
        print "body was empty"
        m.top.result = "empty"
        return
    else
        print "body was not empty"
    end if

    print "current links"
    for each item in m.global.resourceLinks
        print item
    end for

    m.bodyJson = ParseJson(m.body)

    print "Links from response"
    for each item in m.bodyJson
        print item
    end for

    m.global.resourceLinks = m.bodyJson

    print "new links"
    for each item in m.global.resourceLinks
        print item
    end for

    m.registry = CreateObject("roRegistrySection", "Config")
    m.registry.Write("imgLinks", FormatJson(m.bodyJson))
    m.registry.Write("loaded", "true")
    m.registry.Flush()

    m.top.result = "done"

end sub

