sub init()
    m.top.functionName = "loadConfig"
end sub

sub loadConfig()

    print "loading config from registry"

    ' FOR TESTING A CLEAN REGISTRY
    ' m.reg = CreateObject("roRegistry")
    ' print "Successfully deleted config from registry: " + m.reg.Delete("Config").ToStr()
    ' m.reg.Flush()

    m.registry = CreateObject("roRegistrySection", "Config")

    if m.registry.Exists("loaded")
        m.global.loaded = m.registry.Read("loaded")
        print "loaded loaded: " + m.global.loaded.ToStr()
    else
        m.registry.Write("loaded", "false")
        m.global.loaded = "false"
    end if

    if m.registry.Exists("background")
        m.global.background = m.registry.Read("background")
        print "loaded background: " + m.global.background.ToStr()
    else
        m.registry.Write("background", "false")
        m.global.background = "false"
    end if

    if m.registry.Exists("displayTime")
        m.global.picDisplayTime = m.registry.Read("displayTime").ToInt()
        print "loaded picDisplayTime: " + m.global.picDisplayTime.ToStr()
    else
        m.registry.Write("displayTime", "10")
        m.global.picDisplayTime = 10
    end if

    if m.registry.Exists("imgLinks")

        m.global.resourceLinks = ParseJson(m.registry.Read("imgLinks"))

        if m.global.resourceLinks = invalid
            print "loaded resource links were invalid"
            m.global.resourceLinks = {}
            m.registry.Write("loaded", "false")
            m.registry.Write("imgLinks", "")
            m.global.loaded = "false"
        else
            print "loaded resourceLinks: "
            for each item in m.global.resourceLinks
                print item
            end for
        end if
    else
        m.global.resourceLinks = {}
        m.global.loaded = "false"
        m.registry.Write("loaded", "false")
        m.registry.Write("imgLinks", "")
    end if

    m.registry.Flush()

    m.global.filenameCounter = 0
    m.global.imgIndex = 0
    m.global.imageUri = ""
    m.global.certificates = "common:/certs/ca-bundle.crt"
    m.global.folderPath = "pkg:/images/wallpapers/"
    m.global.backgroundColor = "#FFFFFF"
    m.global.webappUrl = "http://10.0.0.15:8080"

    print "Finished loading config"

    m.top.result = "done"

end sub