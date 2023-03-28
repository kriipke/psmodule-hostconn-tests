<#
 .Synopsis
  Confirm the ability to ping a host by IP address.

 .Description
  Pings a single IP address or comma separated list and reports the success or failure of the command ping -n 1 $IPAddress.

 .Parameter IPAddress
  Single IP or list of comma separated IPs.

 .Example
   # Return the success or failure of the attempt to ping 10.0.0.1
   Test-Ping 10.0.0.1
#>
function Test-Ping {
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Alias("IP")]
        [String[]] $IPAddress
    )
    foreach ($IP in $IPAddress) { 
        Write-Host "Ping ${IP}: " -NoNewLine
        try { 
            ping -n 1 $IP 1>$null
            Write-Host "Succeded" -ForegroundColor green
        }
        catch {
            Write-Host "Failed" -ForegroundColor red
        }
    }   
}
Export-ModuleMember -Function Test-Ping