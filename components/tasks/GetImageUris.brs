sub init()
    m.top.functionName = "getImageUris"
end sub

function getFullFromShortLink(url as string) as boolean

    lightroomShortPrefix = "https://adobe.ly/"
    url = lightroomShortPrefix + url
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    urlTransfer.SetUrl(url)
    urlTransferPort = CreateObject("roMessagePort")
    urlTransfer.SetPort(urlTransferPort)
    urlTransfer.AsyncGetToString()
    responseEvent = Wait(5000, urlTransferPort)
    if responseEvent = invalid
        print "urlTransfer timed out while trying to get long link."
        return false
    end if
    responseHeaders = responseEvent.GetResponseHeadersArray()
    for each item in responseHeaders
        if item.DoesExist("location")
            print "lightroom long link: " + item["location"]
            if item["location"] = "http://www.adobe.com"
                print "getFullFromShortLink returned false because location was www.adobe.com"
                return false
            else
                m.global.longLightroomAlbumUrl = item["location"]
                print "in else"
                return true
            end if
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
    if response = invalid
        m.top.result = "Failed to get response from Lightroom using long link."
        return
    end if

    albumJsonMarker = "albumAttributes"
    indexOfAlbumJson = Instr(1, response, albumJsonMarker) + Len(albumJsonMarker) + 1
    endIndexOfAlbumJson = Instr(indexOfAlbumJson, response, "};") - 1

    try
        albumJsonString = Mid(response, indexOfAlbumJson, endIndexOfAlbumJson - indexOfAlbumJson)
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


    ' ADD LOGIC TO FIND THE HIGHEST QUALITY IMAGE LINK
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
