sub init()
    m.top.functionName = "revokeAccess"
end sub

sub revokeAccess()

    m.payload = {
        "Links": m.global.resourceIds
        "RokuId": m.global.clientId
    }

    m.payloadJson = FormatJson(m.payload)

    print m.payloadJson

    m.revokeTransfer = CreateObject("roUrlTransfer")
    print m.revokeTransfer.SetCertificatesFile(m.global.certificates)
    m.revokeTransferPort = CreateObject("roMessagePort")

    m.revokeTransfer.SetUrl(m.global.webappUrl + "/link/revoke")
    m.revokeTransfer.AddHeader("Content-Type", "application/json")
    m.revokeTransfer.SetPort(m.revokeTransferPort)
    response = m.revokeTransfer.PostFromString(m.payloadJson)
    print response.ToStr()

    m.top.result = response.ToStr()
end sub