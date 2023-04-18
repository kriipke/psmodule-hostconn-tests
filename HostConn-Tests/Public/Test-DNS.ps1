<#
 .Synopsis
  Confirm the successfully reslution of a hostname.

 .Description
  Confirm that the hostname given successfully resolves to an A record(s).
  and lets you highlight specific date ranges or days.

 .Parameter Host
  Hostname to resolve via DNS.

 .Example
   # Resolve google.com to a list of A records (IPv4).
   Test-DNS "google.com"

 .Example
   # Resolve google.com to a list of AAA records (IPv6).
   Test-DNS -Type "AAA" -Host "google.com"
#>
function Test-DNS {
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Alias("Host")]
        [String] $FQDN,

        [Parameter(
            ValueFromPipeline = $true
        )]
        [Alias("RecordType")]
        [ValidateSet("A", "AAA")]
        [String] $Type = "A"
    )

    Write-Host "DNS Resolution ($FQDN): " -NoNewline

    try {
        $ResolvedIPs = $(Resolve-DnsName -Name $FQDN -Type A | Select-Object -Property IPAddress)
        if ($ResolvedIPs -ne $null) {
            Write-Host "Succeded" -ForegroundColor green
            Write-Output $ResolvedIPs.IPAddress
        } else {
            Throw "`$ResolvedIPs was empty."
        }
    }
    catch { 
        Write-Host "Failed" -ForegroundColor red
    }
}
Export-ModuleMember -Function Test-DNS