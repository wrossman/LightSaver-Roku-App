sub init()

m.titleLabel = m.top.findNode("titleLabel")
m.titleLabel.width = CreateObject("roDeviceInfo").GetDisplaySize().w

end sub