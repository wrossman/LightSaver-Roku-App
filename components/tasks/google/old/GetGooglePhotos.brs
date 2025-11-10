sub init()

    m.top.functionname = "getAuthUrl"

end sub

sub getAuthUrl()

    m.authUrlTask = CreateObject("roSGNode", "GetGoogleAuthUrl")
    m.authUrlTask.control = "run"
    m.authUrlTask.observeField("result", "getAuthToken")

end sub

sub getAuthToken()

    ' m.authUrlTask.unobserveField("result")
    'add tests
    m.authTokenTask = CreateObject("roSGNode", "GetGoogleAuthToken")
    m.authTokenTask.control = "run"
    'm.authUrlTask.observeField("result", "")

end sub