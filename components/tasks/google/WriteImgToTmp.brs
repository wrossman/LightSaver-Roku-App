sub init()
    m.top.functionName = "WriteImgToTmp"
end sub

sub WriteImgToTmp()

    print "Running writeimgtotmp"
    fs = CreateObject("roFileSystem")
    fs.Delete(m.global.googleUri)

    ' this can be sent to a global variable so it doesnt run everytime
    m.keyList = []
    for each item in m.global.googleImgLinks
        m.keyList.Push(item)
    end for

    if m.global.googleImgIndex = m.keyList.Count()
        m.global.googleImgIndex = 0
    end if

    m.currHeader = {
        "Authorization": m.global.googleImgLinks[m.keyList[m.global.googleImgIndex]],
        "Location": m.keyList[m.global.googleImgIndex],
        "Device": m.global.clientId
    }

    m.imageHttp = CreateObject("roUrlTransfer")
    m.imageHttp.SetHeaders(m.currHeader)
    m.imageHttp.SetUrl("http://10.0.0.15:8080/google/roku-get-resource")
    m.imgHttpPort = CreateObject("roMessagePort")
    m.imageHttp.SetPort(m.imgHttpPort)
    m.imageHttp.AsyncGetToFile("tmp:/googleImg")
    m.imgResponse = Wait(5000, m.imgHttpPort)

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

    m.finalImgName = "tmp:/googleImg" + m.global.googleImgIndex.ToStr() + "." + m.cleanType


    success = fs.CopyFile("tmp:/googleImg", m.finalImgName)
    fs.Delete("tmp:/googleImg")

    if success
        m.global.googleUri = m.finalImgName
        m.top.result = m.finalImgName
    else
        print "failed to rename the google img file"
    end if

end sub