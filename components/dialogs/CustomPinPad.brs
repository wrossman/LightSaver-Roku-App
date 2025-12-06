sub init()

    m.top.keyGrid.keyDefinitionUri = "pkg:/components/data/customPinpadKDF.json"

end sub

function keySelected(key as string) as boolean
    if key = "enter"

        if m.top.text = ""
            return true
        end if

        m.time = m.top.text.ToInt()

        if m.time < 1
            return true
        end if

        m.global.picDisplayTime = m.time
        m.registry = CreateObject("roRegistrySection", "Config")
        m.registry.Write("displayTime", m.global.picDisplayTime.ToStr())
        m.registry.Flush()

        changeTime = m.top.getParent()

        settings = changeTime.getParent()
        settings.removeChild(changeTime)
        settingsSelection = settings.findNode("settingsSelection")
        settingsSelection.setFocus(true)
        return true ' key selection is handled, return true
    end if
    ' if not handled, return false to use default DynamicCustomKeyboard keySelected handlers
    return false
end function