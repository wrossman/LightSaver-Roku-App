sub init()

    m.top.functionname = "getGoogleAuthUrl"

end sub

sub getGoogleAuthUrl()

    url = m.global.googleDiscDocUrl
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    urlTransfer.SetUrl(url)
    urlResponse = urlTransfer.GetToString()
    discoveryJson = ParseJson(urlResponse)
    m.top.result = discoveryJson["device_authorization_endpoint"]

    m.global.googleAuthUrl = m.top.result

    print m.top.result

end sub