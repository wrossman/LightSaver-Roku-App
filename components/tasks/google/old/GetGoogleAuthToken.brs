sub init()

    m.top.functionname = "getGoogleAuthToken"

end sub

sub getGoogleAuthToken()

    url = m.global.googleAuthUrl
    ' "client_id=client_id&scope=email%20profile"
    postBody = "client_id=" + m.global.googleClientID + "&scope=" + m.global.googlePhotosScope
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    urlTransfer.SetUrl(url)
    urlTransferPort = CreateObject("roMessagePort")
    urlTransfer.SetPort(urlTransferPort)
    urlResponse = urlTransfer.AsyncPostFromString(postBody)
    print urlResponse
    responseEvent = Wait(5000, urlTransferPort)

    print responseEvent.GetInt()
    print responseEvent.GetString()


    print m.top.result

end sub