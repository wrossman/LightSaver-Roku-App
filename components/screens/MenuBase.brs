sub init()

    m.leftRect = m.top.findNode("left")
    m.rightRect = m.top.findNode("right")
    m.title = m.top.findNode("title")

    m.leftRect.height = m.global.deviceSize["h"]
    m.leftRect.width = m.global.deviceSize["w"] / 2

    m.rightRect.height = m.global.deviceSize["h"]
    m.rightRect.width = m.global.deviceSize["w"] / 2
    m.rightRect.translation = [m.global.deviceSize["w"] / 2, 0]

    m.title.width = m.global.deviceSize["w"] / 2
    m.title.font.uri = "pkg:/components/data/fonts/" + m.global.titleFont
    m.title.font.size = 100
    m.title.translation = [0, m.global.deviceSize["h"] / 7]

end sub