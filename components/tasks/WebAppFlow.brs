sub init()
    m.top.functionName = "startWebAppFlow"
end sub

sub startWebAppFlow()
    m.getSessionCodeTask = m.top.findNode("GetSessionCodeTask")
    m.getSessionCodeTask.observeField("result", "startPollTask")
    m.getSessionCodeTask.control = "run"
end sub

sub startPollTask()
    m.getSessionCodeTask.unobserveField("result")
    if m.getSessionCodeTask.result = "fail"
        m.top.result = "fail"
        return
    end if

    m.top.sessionCode = m.getSessionCodeTask.sessionCode

    m.pollTask = m.top.findNode("PollLightSaverWebApp")
    m.pollTask.observeField("result", "startGetResource")
    m.pollTask.control = "run"

end sub

sub startGetResource()
    m.pollTask.unobserveField("result")

    m.getResourcePackageTask = m.top.findNode("GetResourcePackage")
    m.getResourcePackageTask.observeField("result", "finishFlow")
    m.getResourcePackageTask.control = "run"
end sub

sub finishFlow()
    m.getResourcePackageTask.unobserveField("result")

    m.top.resourcePackage = m.getResourcePackageTask.resourcePackage
    m.top.result = "done"
end sub