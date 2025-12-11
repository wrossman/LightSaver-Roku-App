sub init()
    m.top.functionName = "getLinksFromRegistry"
end sub

sub getLinksFromRegistry()

    m.regConfig = CreateObject("roRegistrySection", "Config")

    if m.global.resourceIds.Count() = 0
        m.top.result = "fail"
        return
    end if

    m.global.imageCount = m.global.resourceIds.Count()
    m.top.result = "success"

end sub