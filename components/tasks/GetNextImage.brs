sub init()

    m.top.functionName = "getNextImage"

end sub

sub getNextImage()

    print "Running Get Next Image"
    fs = CreateObject("roFileSystem")
    fs.Delete(m.global.imageUri)

    ' this can be sent to a global variable so it doesnt run everytime
    m.keyList = []
    for each item in m.global.resourceLinks
        m.keyList.Push(item)
    end for

    if m.global.imgIndex >= m.keyList.Count()
        m.global.imgIndex = 0
    end if

    m.currHeader = {
        "Authorization": m.global.resourceLinks[m.keyList[m.global.imgIndex]],
        "Location": m.keyList[m.global.imgIndex],
        "Device": m.global.clientId
    }

    m.imageHttp = CreateObject("roUrlTransfer")
    m.imageHttp.SetHeaders(m.currHeader)
    m.imageHttp.SetUrl("http://10.0.0.15:8080/roku/get-resource")
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

    m.finalImgName = "tmp:/img" + m.global.filenameCounter.ToStr() + "." + m.cleanType

    success = fs.CopyFile("tmp:/" + m.global.filenameCounter.ToStr(), m.finalImgName)
    fs.Delete("tmp:/" + m.global.filenameCounter.ToStr())

    m.global.filenameCounter++

    if success
        m.global.imageUri = m.finalImgName
        m.global.imgIndex++
        m.top.result = m.finalImgName
    else
        print "failed to rename the img file"
    end if

    print "Finish get next image"
end sub

sub getNextLightroomImage()
    print "in get next lightroom image"

    fs = CreateObject("roFileSystem")
    fs.Delete(m.global.imageUri)

    if m.global.imgIndex >= m.global.imageUriArr.Count()
        m.global.imgIndex = 0
    end if

    print m.global.imgIndex
    m.imageHttp = CreateObject("roUrlTransfer")
    m.imageHttp.SetUrl(m.global.imageUriArr[m.global.imgIndex])
    m.imgHttpPort = CreateObject("roMessagePort")
    m.imageHttp.SetPort(m.imgHttpPort)
    m.imageHttp.AsyncGetToFile("tmp:/img" + m.global.filenameCounter.ToStr())
    m.imgResponse = Wait(5000, m.imgHttpPort)

    if m.imgResponse <> invalid
        print "successfully got response in getnext lightroom image"
        m.global.imageUri = "tmp:/img" + m.global.filenameCounter.ToStr()
        m.global.imgIndex++
        m.top.result = "tmp:/img" + m.global.filenameCounter.ToStr()
    else
        print "failed to get image from lightroom uri arr"
        m.top.result = "fail"
        return
    end if

    m.global.filenameCounter++

end sub