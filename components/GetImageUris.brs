sub init()
    m.top.functionName = "getImageUris"
end sub

function getFullFromShortLink(url as string) as boolean

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
            m.global.longLightroomAlbumUrl = item["Location"]
            return true
        end if
    end for
    return false
end function

sub getImageUris()

    if m.global.lightroomAlbumUrl = invalid
        m.top.result = "nullLightroomAlbumUrl"
        return
    end if
    if getFullFromShortLink(m.global.lightroomAlbumUrl) = false
        m.top.result = "Failed to get full album url from short"
        return
    end if

    myAlbumUrl = m.global.longLightroomAlbumUrl
    baseUrl = "https://photos.adobe.io/v2/"
    endpointUrlEnd = "/assets?embed=asset&subtype=image%3Bvideo"

    myUrlTransfer = CreateObject("roUrlTransfer")
    myUrlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    myUrlTransfer.SetUrl(myAlbumUrl)
    response = myUrlTransfer.GetToString()

    try
        albumJsonMarker = "albumAttributes"
        indexOfAlbumJson = Instr(1, response, albumJsonMarker) + Len(albumJsonMarker) + 1
        endIndexOfAlbumJson = Instr(indexOfAlbumJson, response, "};") - 1
        albumJsonString = Mid(response, indexOfAlbumJson, endIndexOfAlbumJson - indexOfAlbumJson)
    catch e
        print "Error in retrieving albumJsonString: " + e.message
        m.top.result = "Failed to grab albumJsonString from inital response."
        return
    end try

    try
        albumJson = ParseJson(albumJsonString)
        albumAssetUrl = albumJson.links.self["href"]
        spaceUrl = Left(albumAssetUrl, Instr(1, albumAssetUrl, "/albums"))
    catch e
        print "Failed to parse albumJsonString as JSON: " + e.message
        m.top.result = "Failed to parse albumJsonString as JSON."
        return
    end try

    albumUrl = baseUrl + albumAssetUrl + endpointUrlEnd

    try
        myUrlTransfer.SetUrl(albumUrl)
        response = myUrlTransfer.GetToString()
        finalResponse = Mid(response, 13).trim()
        finalJson = ParseJson(finalResponse)
    catch e
        print "Failed to retrieve final JSON: " + e.message
        m.top.result = "Failed to retrieve final JSON."
        return
    end try

    outputArr = []

    for each item in finalJson.resources
        itemUrl = baseUrl + spaceUrl + item.asset.links["/rels/rendition_type/1280"]["href"]
        outputArr.Push(itemUrl)
    end for

    fs = CreateObject("roFileSystem")
    fileList = fs.GetDirectoryListing(m.global.folderPath)
    for each item in fileList
        outputArr.Push(m.global.folderPath + item)
    end for

    m.global.imageUriArr = CreateObject("roArray", 1, true)
    m.global.imageUriArr = outputArr

    m.top.result = "success"
    print "Get URI Task Succeeded "
    
end sub
