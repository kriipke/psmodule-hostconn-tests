<#
 .Synopsis
  Queries a hostname's HTTP server to make sure that connectivity is possible.

 .Description
  Optionally query via HTTP, HTTPS or both to get the status code and status description returned by the HTTP(S) response.

 .Parameter Host
  FQDN of the server to be queried, e.g. google.com

 .Parameter Protocols
  Either a single string or list of strings composed of HTTP, HTTPS or both.

 .Example
  # Makes sure google.com is responding to HTTP request on port 80
  Test-HTTP "google.com" 

 .Example
   # Ensure the web server running on localhost is responding on both ports 80 & 443
   Test-HTTP -FQDN "localhost" -Protocols HTTP,HTTPS
#>
function Test-HTTP {
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Alias("Host")]
        [String] $FQDN,

        [Parameter(
            HelpMessage = "Protocols to use, either HTTP or HTTPS or both (HTTP,HTTPS)."
        )]
        [string[]] $Protocols = @("HTTP", "HTTPS")
    )

    foreach ($Protocol in $Protocols) {
        $Protocol = $($Protocol.toUpper())
        try { 
            $URL = "$($Protocol.toLower())://$FQDN"
            $HTTPResponseObject = $(Invoke-WebRequest -Uri $URL -UseBasicParsing -MaximumRedirection 0 2>$null | Select-Object -Property StatusCode, StatusDescription)
            $ResponseStatusCode = "$($HTTPResponseObject.StatusCode), $($HTTPResponseObject.StatusDescription)"
            Write-Host "$Protocol Request (${URL}): " -NoNewLine
            if (200 -lt $HTTPResponse.StatusCode -lt 299) {
                Write-Host "Succeded ($ResponseStatusCode)" -ForegroundColor green
            }
            elseif (400 -lt $HTTPResponse.StatusCode -lt 499) {
                Write-Host "Failed, Client-side Error ($ResponseStatusCode)" -ForegroundColor red
            }
            elseif (500 -lt $HTTPResponse.StatusCode -lt 599) {
                Write-Host "Failed, Server-side Error ($ResponseStatusCode)" -ForegroundColor red
            }
            else {
                Write-Host "Failed, Unknown ($ResponseStatusCode)" -ForegroundColor red
            }
        }
        catch {
            switch ($Protocol) {
                HTTP { $PortNumber = 80 }
                HTTPS { $PortNumber = 443 }
                * { $PortNumber = $null }
            }
            Write-Host "Failed to query $($Protocol.toLower())://$FQDN on port $PortNumber, make sure server is up and port is unblocked." -ForegroundColor red
        }
    }
}
Export-ModuleMember -Function Test-HTTP