# Test-HostConnectivity PowerShell Module

This PowerShell module is a simple but handy network troubleshooting and connectivity test tool. It was designed for technical support teams to quick check whether the local machine can access another host running a web service, among other things.


# Usage

    Import-Module ./Test-HostConnectivity.psm1
    Test-HostConnectivity "google.com"

The following is expected output:

    TESTING DNS RESOLUTION...
    DNS Resolution (google.com): Succeded
    74.125.138.139
    74.125.138.138
    74.125.138.100
    74.125.138.102
    74.125.138.113
    74.125.138.101

    TESTING (ping) CONNECTIVITY...
    Ping 74.125.138.139: Succeded
    Ping 74.125.138.138: Succeded
    Ping 74.125.138.100: Succeded
    Ping 74.125.138.102: Succeded
    Ping 74.125.138.113: Succeded
    Ping 74.125.138.101: Succeded

    TESTING HTTP REQUEST...
    HTTP Request (http://google.com): Succeded (200, OK)

    TESTING HTTPS REQUEST...
    HTTPS Request (https://google.com): Succeded (200, OK)
