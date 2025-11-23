sub init()
    m.top.functionName = "getLinksFromRegistry"
end sub

sub getLinksFromRegistry()

    ' Registry is read on start of MainScene so this is just a place holder if any other processing needs to be done
    ' in the future

    m.regConfig = CreateObject("roRegistrySection", "Config")

    ' if m.regConfig.Exists("imgLinks")
    '     m.global.resourceLinks = ParseJson(m.regConfig.Read("imgLinks"))
    '     if m.global.resourceLinks = invalid
    '         m.top.result = "fail"
    '         return
    '     end if
    '     print "Google Links count from config = " m.global.resourceLinks.Count()
    '     m.global.imageCount = m.global.resourceLinks.Count()
    '     m.top.result = "success"
    '     for each item in m.global.resourceLinks
    '         print item
    '     end for
    ' else
    '     ' throw error and point user to re add google photos
    '     m.top.result = "fail"
    ' end if

    if m.global.resourceLinks.Count() = 0
        m.top.result = "fail"
        return
    end if

    m.global.imageCount = m.global.resourceLinks.Count()
    m.top.result = "success"

end sub