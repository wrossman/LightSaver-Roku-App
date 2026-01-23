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

        m.global.resourceIds = ParseJson(m.registry.Read("imgLinks"))

        if m.global.resourceIds = invalid
            print "loaded resource links were invalid"
            m.global.resourceIds = {}
            m.registry.Write("loaded", "false")
            m.registry.Write("imgLinks", "")
            m.global.loaded = "false"
        else
            print "loaded resourceIds: "
            for each item in m.global.resourceIds
                print item
            end for
        end if
    else
        m.global.resourceIds = {}
        m.global.loaded = "false"
        m.registry.Write("loaded", "false")
        m.registry.Write("imgLinks", "")
    end if

    m.registry.Flush()

    m.global.filenameCounter = 0
    m.global.imgIndex = 0
    m.global.imageUri = ""
    m.global.backgroundColor = "#001C30"
    m.global.fadeColor = "#FFFFFF"
    m.global.titleFont = "charger-font/ChargerBold-gXaY.otf"
    m.global.baseFont = "charger-font/Charger-XRDo.otf"
    m.global.firstLaunch = "true"
    m.global.deviceSize = getDeviceSize()
    m.global.clientId = getChannelClientId()

    deployment = "aws"

    if deployment = "aws"
        m.global.webappUrl = "https://alpha.lightsaver.photos"
        m.global.certificates = "common:/certs/ca-bundle.crt"
    else if deployment = "azure"
        m.global.webappUrl = "https://roku.lightsaver.photos"
        m.global.certificates = "common:/certs/ca-bundle.crt"
    else if deployment = "local"
        m.global.webappUrl = "https://10.0.0.15:8443"
        m.global.certificates = "pkg:/components/data/certs/rootCA.crt"
    end if

    m.top.palette = {
        DialogBackgroundColor: "0xF0F0F0FF",
        DialogItemColor: "0x001C30FF",
        DialogTextColor: "0x001C30FF",
        DialogFocusColor: "0x001A36FF",
        DialogFocusItemColor: "0xFFFFFFFF",
        DialogSecondaryTextColor: "0x001C30FF",
        DialogSecondaryItemColor: "0x001C3066",
        DialogInputFieldColor: "0x001A36FF",
        DialogKeyboardColor: "0x001C30FF",
        DialogFootprintColor: "0x001C3080"
    }

    print "Finished loading config"

    m.top.result = "done"

end sub

function getDeviceSize()
    devInfo = CreateObject("roDeviceInfo")
    size = devInfo.GetDisplaySize()
    return size
end function

function getChannelClientId()

    devInfo = CreateObject("roDeviceInfo")
    devSerial = devInfo.GetChannelClientId()

    ba = CreateObject("roByteArray")
    ba.FromAsciiString(devSerial)

    digest = CreateObject("roEVPDigest")
    digest.Setup("sha256")
    result = digest.Process(ba)

    return result

end function