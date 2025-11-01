sub Main()

    folderPath = "pkg:/images/wallpapers/"
    lightroomAlbumUrl = "https://lightroom.adobe.com/shares/ed159d42b0474d3eb14ff0bd7da4a187"

    imageUriArr = []
    fileArr = getLocalImages(folderPath)
    lightroomArr = getLightroomUrls(lightroomAlbumUrl)

    for each item in lightroomArr
        imageUriArr.Push(item)
    end for

    for each item in fileArr
        imageUriArr.Push(item)
    end for

    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    scene = screen.CreateScene("MainScene")

    m.global = screen.getGlobalNode()
    m.global.AddField("deviceSize", "assocarray", true)
    m.global.AddField("wallpaperOpen", "bool", true)
    m.global.AddField("imageUriArr", "array", true)
    m.global.AddField("folderPath", "string", true)
    m.global.AddField("backgroundColor", "string", true)
    m.global.backgroundColor = "#FFFFFF"
    m.global.deviceSize = getDeviceSize()
    m.global.imageUriArr = imageUriArr
    m.global.folderPath = folderPath

    for each item in m.global.imageUriArr
        print item
    end for

    print m.global.imageUriArr.Count()

    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

function getLightroomUrls(myAlbumUrl as string) as object

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

    return outputArr

end function

function getLocalImages(folderPath as string) as object

    fs = CreateObject("roFileSystem")
    fileList = fs.GetDirectoryListing(folderPath)
    fileArr = []
    for each item in fileList
        fileArr.Push(folderPath + item)
    end for

    return fileArr

end function

function getDeviceSize()

    devInfo = CreateObject("roDeviceInfo")
    return devInfo.GetDisplaySize()

end function