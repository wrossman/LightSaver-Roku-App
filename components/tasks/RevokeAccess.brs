sub init()
    m.top.functionName = "revokeAccess"
end sub

sub revokeAccess()

    m.payload = {
        "Links": m.global.resourceLinks
        "RokuId": m.global.clientId
    }

    m.payloadJson = FormatJson(m.payload)

    print m.payloadJson

    m.revokeTransfer = CreateObject("roUrlTransfer")
    m.revokeTransferPort = CreateObject("roMessagePort")

    m.revokeTransfer.SetUrl("http://10.0.0.15:8080/link/revoke")
    m.revokeTransfer.AddHeader("Content-Type", "application/json")
    m.revokeTransfer.SetPort(m.revokeTransferPort)
    response = m.revokeTransfer.PostFromString(m.payloadJson)
    print response.ToStr()

    m.top.result = response.ToStr()
end sub