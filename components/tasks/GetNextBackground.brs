sub init()

    m.top.functionName = "GetNextBackground"

end sub

sub GetNextBackground()

    print "Running Get Next Background"
    fs = CreateObject("roFileSystem")
    fs.Delete(m.global.backgroundUri)

    ' if m.global.imgIndex >= m.global.keyList.Count()
    '     m.global.imgIndex = 0
    ' end if

    m.currHeader = {
        "Authorization": m.global.resourceLinks[m.global.keyList[m.global.imgIndex]],
        "ResourceId": m.global.keyList[m.global.imgIndex],
        "Device": m.global.clientId,
        "Height": m.global.deviceSize["h"].ToStr(),
        "Width": m.global.deviceSize["w"].ToStr()
    }

    m.imageHttp = CreateObject("roUrlTransfer")
    m.imageHttp.SetHeaders(m.currHeader)
    m.imageHttp.SetUrl("http://10.0.0.15:8080/link/background")
    m.imgHttpPort = CreateObject("roMessagePort")
    m.imageHttp.SetPort(m.imgHttpPort)
    m.imageHttp.AsyncGetToFile("tmp:/" + m.global.filenameCounter.ToStr())
    m.imgResponse = Wait(5000, m.imgHttpPort)

    ' handle if the keys did not work at the web app

    m.responseCode = m.imgResponse.GetResponseCode()

    if m.responseCode <> invalid
        print "response code valid " + m.responseCode.ToStr()
        if m.responseCode = 401
            print "response code equals 401"
            m.top.result = "401"
            return
        end if
    end if

    if m.responseCode <> 200
        m.top.result = "fail"
        return
    end if

    if m.imgResponse <> invalid
        m.responseHeaders = m.imgResponse.GetResponseHeaders()
        for each item in m.responseHeaders
            if item = "content-type"
                m.fileType = m.responseHeaders[item]
                m.cleanType = Mid(m.fileType, Len("image/j"))
            end if
        end for
    else
        m.top.result = "fail"
        return
    end if

    m.finalImgName = "tmp:/background" + m.global.filenameCounter.ToStr() + "." + m.cleanType

    success = fs.CopyFile("tmp:/" + m.global.filenameCounter.ToStr(), m.finalImgName)
    fs.Delete("tmp:/" + m.global.filenameCounter.ToStr())

    if success
        m.global.backgroundUri = m.finalImgName
        m.top.result = m.finalImgName
    else
        print "failed to rename the background file"
    end if

    print "Finish get next background"
end sub