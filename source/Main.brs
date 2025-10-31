sub Main()

    folderPath = "pkg:/images/wallpapers/"
    fs = CreateObject("roFileSystem")
    fileList = fs.GetDirectoryListing(folderPath)
    fileArr = []
    for each item in fileList
        fileArr.Push(folderPath + item)
    end for

    lightroomArr = getLightroomUrls()
    for each item in lightroomArr
        fileArr.Push(item)
    end for

    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    scene = screen.CreateScene("MainScene")

    m.global = screen.getGlobalNode()
    m.global.AddField("fileArr", "array", true)
    m.global.AddField("folderPath", "string", true)
    m.global.fileArr = fileArr
    m.global.folderPath = folderPath

    for each item in m.global.fileArr
        print item
    end for

    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

function getLightroomUrls() as object

    endpointUrlEnd = "/assets?embed=asset&subtype=image%3Bvideo"
    baseUrl = "https://photos.adobe.io/v2/"
    myAlbumUrl = "https://lightroom.adobe.com/shares/ed159d42b0474d3eb14ff0bd7da4a187"

    myUrlTransfer = CreateObject("roUrlTransfer")
    myUrlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")

    myUrlTransfer.SetUrl(myAlbumUrl)
    response = myUrlTransfer.GetToString()

    indexOfAlbumJson = Instr(1, response, "albumAttributes") + 16
    endIndexOfAlbumJson = Instr(indexOfAlbumJson, response, "};") - 1
    albumJsonString = Mid(response, indexOfAlbumJson, endIndexOfAlbumJson - indexOfAlbumJson)

    albumJson = ParseJson(albumJsonString)
    albumAssetUrl = albumJson.links.self["href"]
    spaceUrl = Left(albumAssetUrl, Instr(1, albumAssetUrl, "/albums"))

    albumUrl = baseUrl + albumAssetUrl + endpointUrlEnd

    myUrlTransfer.SetUrl(albumUrl)
    response = myUrlTransfer.GetToString()

    cleanRespone = Mid(response, 13).trim()
    cleanJson = ParseJson(cleanRespone)

    outputArr = []

    for each item in cleanJson.resources
        itemUrl = baseUrl + spaceUrl + item.asset.links["/rels/rendition_type/1280"]["href"]
        outputArr.Push(itemUrl)
    end for

    return outputArr

end function
