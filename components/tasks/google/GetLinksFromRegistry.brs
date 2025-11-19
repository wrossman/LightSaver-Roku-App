sub init()
    m.top.functionName = "getLinksFromRegistry"
end sub

sub getLinksFromRegistry()

    ' Registry is read on start of MainScene so this is just a place holder if any other processing needs to be done
    ' in the future

    ' m.regConfig = CreateObject("roRegistrySection", "Config")

    ' if m.regConfig.Exists("googleLinks")
    '     m.global.googleImgLinks = ParseJson(m.regConfig.Read("googleLinks"))
    '     print "Google Links count from config = " m.global.googleImgLinks.Count()
    '     m.global.imageCount = m.global.googleImgLinks.Count()
    '     m.top.result = "success"
    ' else
    '     ' throw error and point user to re add google photos
    '     m.top.result = "fail"
    ' end if

    m.global.imageCount = m.global.googleImgLinks.Count()
    m.top.result = "success"

end sub