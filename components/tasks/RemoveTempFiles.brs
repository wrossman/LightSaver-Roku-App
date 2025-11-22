sub init()
    m.top.functionName = "removeTempFiles"
end sub

sub removeTempFiles()
    m.fs = CreateObject("roFileSystem")
    m.tempDir = m.fs.GetDirectoryListing("tmp:/")
    print "Removing temp files"
    for each item in m.tempDir
        print item " deleted?"
        print m.fs.Delete("tmp:/" + item)
    end for
end sub