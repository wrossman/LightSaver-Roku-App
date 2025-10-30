sub Main()

    folderPath = "pkg:/images/wallpapers/"
    fs = CreateObject("roFileSystem")
    fileList = fs.GetDirectoryListing(folderPath)
    fileArr = []
    for each item in fileList
        fileArr.Push(item)
    end for

    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    scene = screen.CreateScene("MainScene")

    m.global = screen.getGlobalNode()
    m.global.AddField("fileArr", "array", true)
    m.global.AddField("folderPath", "string", true)
    m.global.fileArr = fileArr
    m.global.folderPath = folderPath

    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

