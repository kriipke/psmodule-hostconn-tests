<#
 .Synopsis
  Runs commonly executed test to confirm connectivity between the local machine and another host.

 .Description
  Confirms things such as DNS resolution, ability to ping the host, and the ability to property send and receive HTTP(S) requests to the given host. The tool is most useful for diagnosing connectivity issues between the local machine and a web server, either on the local network or an external one, e.g. the internet.
  
 .Parameter Host
  Hostname to perform connectivity tests against. This is the hostname of the machine you want to ensure conncetivity to.

 .Example
   # Test connectivity to google.com
   Test-HostConnectivity "google.com"

 .Example
   # Test connectivity to a web server running on localhost
   Test-HostConnectivity "localhost"
#>
function Test-HostConnectivity {
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true
    )]
    [Alias("Host")]
    [String] $FQDN
  )
  $RE_IPAddress = '^(?:\d{1,3}\.){3}\d{1,3}$'
  if ($FQDN -match $RE_IPAddress) {
    $IPAddresses = $FQDN
  } else {
    Write-Host "`nTESTING DNS RESOLUTION..." -ForegroundColor "blue" 
    Test-DNS $FQDN | Tee-Object -Variable IPAddresses
  }

  Write-Host "`nTESTING IP (ping) CONNECTIVITY..." -ForegroundColor "blue" 
  if ($IPAddresses -ne $null) {
    Test-Ping $IPAddresses
  } else {
    Write-Host "`CANNOT TEST IP (ping) CONNECTIVITY BECAUSE IP ADDRESS COULD NOT BE DETERMINED." -ForegroundColor "Yellow" 
  }

  Write-Host "`nTESTING HTTP REQUEST..." -ForegroundColor "blue" 
  Test-HTTP -Protocols "HTTP" -FQDN $FQDN

  Write-Host "`nTESTING HTTPS REQUEST..." -ForegroundColor "blue" 
  Test-HTTP -Protocols "HTTPS" -FQDN $FQDN

  Write-Host "`n"
}
Export-ModuleMember -Function Test-HostConnectivity