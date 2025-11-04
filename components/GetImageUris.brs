sub init()
    print "start get uri task"
    m.top.functionName = "getImageUris"

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

    m.global.imageUriArr = CreateObject("roArray", 1, true)

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

    fs = CreateObject("roFileSystem")
    fileList = fs.GetDirectoryListing(m.global.folderPath)
    fileArr = []
    for each item in fileList
        outputArr.Push(m.global.folderPath + item)
    end for

    m.global.imageUriArr = outputArr

    m.top.result = "Finished"

    print "end uri task"
end sub
