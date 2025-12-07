sub init()
    m.top.functionName = "getNextImage"
end sub

sub getNextImage()

    fs = CreateObject("roFileSystem")
    fs.Delete(m.global.imageUri)

    m.global.imgIndex++

    if m.global.resourceLinks = invalid or m.global.keyList = invalid
        m.top.result = "fail"
        return
    else if m.global.resourceLinks.Count() = 0 or m.global.keyList.Count() = 0
        m.top.result = "fail"
        return
    end if

    if m.global.imgIndex >= m.global.keyList.Count()
        m.global.imgIndex = 0
    end if

    m.currHeader = {
        "Authorization": m.global.resourceLinks[m.global.keyList[m.global.imgIndex]],
        "ResourceId": m.global.keyList[m.global.imgIndex],
        "Device": m.global.clientId,
    }

    for each item in m.currHeader
        print item + ": " + m.currHeader[item]
    end for

    m.imageHttp = CreateObject("roUrlTransfer")
    print m.imageHttp.SetCertificatesFile("pkg:/components/data/certs/rootCA.crt")
    m.imageHttp.SetHeaders(m.currHeader)
    m.imageHttp.SetUrl(m.global.webappUrl + "/link/get-resource")
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

    m.finalImgName = "tmp:/img" + m.global.filenameCounter.ToStr() + m.cleanType

    if fs.CopyFile("tmp:/" + m.global.filenameCounter.ToStr(), m.finalImgName)
        fs.Delete("tmp:/" + m.global.filenameCounter.ToStr())
        m.global.filenameCounter++
        m.global.imageUri = m.finalImgName
        m.top.result = m.finalImgName
    else
        m.top.result = "fail"
        return
    end if
end sub