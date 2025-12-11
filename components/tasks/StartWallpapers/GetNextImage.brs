sub init()
    m.top.functionName = "getNextImage"
end sub

sub getNextImage()
    print "In get next image"

    fs = CreateObject("roFileSystem")
    fs.Delete(m.global.imageUri)

    m.global.imgIndex++

    if m.global.resourceIds = invalid or m.global.idList = invalid
        m.top.result = "fail"
        return
    else if m.global.resourceIds.Count() = 0 or m.global.idList.Count() = 0
        m.top.result = "fail"
        return
    end if

    if m.global.imgIndex >= m.global.idList.Count()
        m.global.imgIndex = 0
    end if

    m.currHeader = {
        "Authorization": m.global.resourceIds[m.global.idList[m.global.imgIndex]],
        "ResourceId": m.global.idList[m.global.imgIndex],
        "Device": m.global.clientId,
    }

    for each item in m.currHeader
        print item + ": " + m.currHeader[item]
    end for

    m.imageHttp = CreateObject("roUrlTransfer")
    m.imageHttp.SetCertificatesFile(m.global.certificates)
    m.imageHttp.SetHeaders(m.currHeader)
    m.imageHttp.SetUrl(m.global.webappUrl + "/link/get-resource")
    m.imgHttpPort = CreateObject("roMessagePort")
    m.imageHttp.SetPort(m.imgHttpPort)
    m.imageHttp.AsyncGetToFile("tmp:/" + m.global.filenameCounter.ToStr())
    m.imgResponse = Wait(5000, m.imgHttpPort)

    if m.imgResponse = invalid
        print "imgresponse invalid"
        m.top.result = "fail"
        return
    end if

    m.responseCode = m.imgResponse.GetResponseCode()

    if m.responseCode = 202
        print "Key Update Detected"
        m.keyUpdateBody = ReadAsciiFile("tmp:/" + m.global.filenameCounter.ToStr())
        fs.Delete("tmp:/" + m.global.filenameCounter.ToStr())

        if m.keyUpdateBody = invalid
            m.top.result = "fail"
            return
        end if

        m.keyUpdateJson = ParseJson(m.keyUpdateBody)

        if m.keyUpdateJson = invalid
            m.top.result = "fail"
            return
        end if

        if m.keyUpdateJson.Key = invalid
            m.top.result = "fail"
            return
        end if

        m.newKey = m.keyUpdateJson.Key
        print "New key: " + m.newKey

        print "old keys"
        for each item in m.global.resourceIds
            print m.global.resourceIds[item]
        end for

        m.tempResources = m.global.resourceIds
        m.tempResources[m.global.idList[m.global.imgIndex]] = m.newKey
        m.global.resourceIds = m.tempResources

        print "new keys"
        for each item in m.global.resourceIds
            print m.global.resourceIds[item]
        end for

        resources = FormatJson(m.global.resourceIds)
        m.settings = CreateObject("roRegistrySection", "Config")
        m.settings.Write("imgLinks", resources)
        m.settings.Flush()

        m.freshHeader = {
            "Authorization": m.global.resourceIds[m.global.idList[m.global.imgIndex]],
            "ResourceId": m.global.idList[m.global.imgIndex],
            "Device": m.global.clientId,
        }

        print "New Header"
        for each item in m.freshHeader
            print m.freshHeader[item]
        end for

        m.freshImageHttp = CreateObject("roUrlTransfer")
        m.freshImageHttp.SetCertificatesFile(m.global.certificates)
        m.freshImageHttp.SetHeaders(m.freshHeader)
        m.freshImageHttp.SetUrl(m.global.webappUrl + "/link/get-resource")
        m.freshImgHttpPort = CreateObject("roMessagePort")
        m.freshImageHttp.SetPort(m.freshImgHttpPort)
        m.freshImageHttp.AsyncGetToFile("tmp:/" + m.global.filenameCounter.ToStr())
        m.freshImgResponse = Wait(5000, m.freshImgHttpPort)

        if m.freshImgResponse = invalid
            m.top.result = "fail"
            return
        end if

        m.freshResponseCode = m.freshImgResponse.GetResponseCode()
        print "new response code after key update: " + m.freshResponseCode.ToStr()

        if m.freshResponseCode = 401
            m.top.result = "keyFail"
            return
        end if

        if m.freshResponseCode <> 200
            m.top.result = "fail"
            return
        end if

        m.freshResponseHeaders = m.freshImgResponse.GetResponseHeaders()

        if m.freshResponseHeaders.Lookup("content-type") <> invalid
            m.fileType = m.freshResponseHeaders["content-type"]
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

        print "finish get next image with new key"
        return
    end if

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

    print "finish get next image"
end sub