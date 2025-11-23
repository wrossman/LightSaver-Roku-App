sub init()
    m.top.functionName = "loadConfig"
end sub

sub loadConfig()

    print "loading config from registry"

    m.registry = CreateObject("roRegistrySection", "Config")

    if m.registry.Exists("albumUrl")
        m.global.lightroomAlbumUrl = m.registry.Read("albumUrl")
        print "loaded lightroomAlbumUrl: " + m.global.lightroomAlbumUrl
    else
        m.global.lightroomAlbumUrl = ""
    end if

    if m.registry.Exists("displayTime")
        m.global.picDisplayTime = m.registry.Read("displayTime").ToInt()
        print "loaded picDisplayTime: " + m.global.picDisplayTime.TOStr()
    else
        m.global.picDisplayTime = 10
    end if

    if m.registry.Exists("imgSource")
        m.global.imgSource = m.registry.Read("imgSource")
        print "loaded imgSource: " + m.global.imgSource
    else
        m.global.imgSource = ""
    end if

    if m.registry.Exists("imgLinks")
        m.global.resourceLinks = ParseJson(m.registry.Read("imgLinks"))
        if m.global.resourceLinks = invalid
            m.global.resourceLinks = {}
        end if
        print "loaded resourceLinks: "
        for each item in m.global.resourceLinks
            print item
        end for
    else
        m.global.resourceLinks = {}
    end if

    print "Finished loading config"

    m.top.result = "done"

end sub