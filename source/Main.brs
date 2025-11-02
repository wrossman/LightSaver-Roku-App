sub Main()

    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    scene = screen.CreateScene("MainScene")

    m.global = screen.getGlobalNode()
    m.global.AddField("deviceSize", "assocarray", true)
    m.global.AddField("wallpaperOpen", "bool", true)
    m.global.AddField("settingsOpen", "bool", true)
    m.global.AddField("imageUriArr", "array", true)
    m.global.AddField("folderPath", "string", true)
    m.global.AddField("backgroundColor", "string", true)
    m.global.AddField("lightroomAlbumUrl", "string", true)
    m.global.AddField("urlChange", "int", true)
    m.global.AddField("displayTimeChange", "int", true)


    m.global.folderPath = "pkg:/images/wallpapers/"
    m.global.lightroomAlbumUrl = "470uKsm"
    ' m.global.lightroomAlbumUrl = ""
    m.global.backgroundColor = "#FFFFFF"
    m.global.deviceSize = getDeviceSize()
    ' m.global.observeField("lightroomAlbumUrl", "getImageUris")

    getImageUris()

    screen.show()

    for each item in m.global.imageUriArr
        print item
    end for


    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

function getFullFromShortLink(url as string) as string

    lightroomShortPrefix = "https://adobe.ly/"
    url = lightroomShortPrefix + url
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(url)
    urlTransferPort = CreateObject("roMessagePort")
    urlTransfer.SetPort(urlTransferPort)
    urlTransfer.AsyncGetToString()
    responseEvent = Wait(0, urlTransferPort)
    responseHeaders = responseEvent.GetResponseHeadersArray()
    for each item in responseHeaders
        if item.DoesExist("Location")
            return item["Location"]
        end if
    end for
    return ""
end function

sub getImageUris()

    m.global.imageUriArr = CreateObject("roArray",1,true)

    myAlbumUrl = getFullFromShortLink(m.global.lightroomAlbumUrl)
    baseUrl = "https://photos.adobe.io/v2/"
    endpointUrlEnd = "/assets?embed=asset&subtype=image%3Bvideo"

    myUrlTransfer = CreateObject("roUrlTransfer")
    myUrlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")

    myUrlTransfer.SetUrl(myAlbumUrl)
    response = myUrlTransfer.GetToString()

    albumJsonMarker = "albumAttributes"
    indexOfAlbumJson = Instr(1, response, albumJsonMarker) + Len(albumJsonMarker) + 1
    endIndexOfAlbumJson = Instr(indexOfAlbumJson, response, "};") - 1
    albumJsonString = Mid(response, indexOfAlbumJson, endIndexOfAlbumJson - indexOfAlbumJson)

    albumJson = ParseJson(albumJsonString)
    albumAssetUrl = albumJson.links.self["href"]
    spaceUrl = Left(albumAssetUrl, Instr(1, albumAssetUrl, "/albums"))

    albumUrl = baseUrl + albumAssetUrl + endpointUrlEnd

    myUrlTransfer.SetUrl(albumUrl)
    response = myUrlTransfer.GetToString()

    cleanResponse = Mid(response, 13).trim()
    cleanJson = ParseJson(cleanResponse)

    outputArr = []

    for each item in cleanJson.resources
        itemUrl = baseUrl + spaceUrl + item.asset.links["/rels/rendition_type/1280"]["href"]
        outputArr.Push(itemUrl)
    end for

    ' GET LOCAL IMAGES

    fs = CreateObject("roFileSystem")
    fileList = fs.GetDirectoryListing(m.global.folderPath)
    fileArr = []
    for each item in fileList
        outputArr.Push(m.global.folderPath + item)
    end for

    m.global.imageUriArr = outputArr
end sub

function getDeviceSize()

    devInfo = CreateObject("roDeviceInfo")
    return devInfo.GetDisplaySize()

end function