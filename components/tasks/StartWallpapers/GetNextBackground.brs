sub init()

    m.top.functionName = "GetNextBackground"

end sub

sub GetNextBackground()

    fs = CreateObject("roFileSystem")
    fs.Delete(m.global.backgroundUri)

    if m.global.resourceIds = invalid or m.global.idList = invalid
        m.top.result = "fail"
        return
    else if m.global.resourceIds.Count() = 0 or m.global.idList.Count() = 0
        m.top.result = "fail"
        return
    end if

    m.currHeader = {
        "Authorization": m.global.resourceIds[m.global.idList[m.global.imgIndex]],
        "ResourceId": m.global.idList[m.global.imgIndex],
        "Device": m.global.clientId,
        "Height": m.global.deviceSize["h"].ToStr(),
        "Width": m.global.deviceSize["w"].ToStr()
    }

    m.imageHttp = CreateObject("roUrlTransfer")
    print m.imageHttp.SetCertificatesFile(m.global.certificates)
    m.imageHttp.SetHeaders(m.currHeader)
    m.imageHttp.SetUrl(m.global.webappUrl + "/link/background")
    m.imgHttpPort = CreateObject("roMessagePort")
    m.imageHttp.SetPort(m.imgHttpPort)
    m.imageHttp.AsyncGetToFile("tmp:/" + m.global.filenameCounter.ToStr())
    m.imgResponse = Wait(5000, m.imgHttpPort)

    if m.imgResponse = invalid
        m.top.result = "fail"
        return
    end if

    m.responseCode = m.imgResponse.GetResponseCode()

    if m.responseCode = 401
        m.top.result = "keyFail"
        return
    end if

    if m.responseCode <> 200
        m.top.result = "fail"
        return
    end if

    m.responseHeaders = m.imgResponse.GetResponseHeaders()

    if m.responseHeaders.Lookup("content-type") <> invalid
        m.fileType = m.responseHeaders["content-type"]
        m.cleanType = "." + Mid(m.fileType, Len("image/j"))
        if m.cleanType = "."
            m.cleanType = ""
        end if
    else
        m.cleanType = ""
    end if

    m.finalImgName = "tmp:/background" + m.global.filenameCounter.ToStr() + m.cleanType

    if fs.CopyFile("tmp:/" + m.global.filenameCounter.ToStr(), m.finalImgName)
        fs.Delete("tmp:/" + m.global.filenameCounter.ToStr())
        m.global.backgroundUri = m.finalImgName
        m.top.result = m.finalImgName
    else
        m.top.result = "fail"
        return
    end if
end sub