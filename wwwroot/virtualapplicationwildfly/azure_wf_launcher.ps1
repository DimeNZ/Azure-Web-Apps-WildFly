$httpPlatformPort = (get-item env:"HTTP_PLATFORM_PORT").Value
$homePath = (get-item env:"HOME").Value

$siteRootWF = "$homePath\site\wwwroot\virtualapplicationwildfly"
$clonedWFFolder = "WF_$($env:COMPUTERNAME)_$(Get-Date -format 'yyyyMMdd_HHmmss')_$($httpPlatformPort)"

Write-Output "Step 1, clean up old folders"
Get-ChildItem -Path $siteRootWF -Filter "WF_$($env:COMPUTERNAME)_*" -Directory | 
                            sort -Property CreationTime -Descending | 
                            select -Skip 1 | 
                            Remove-Item -Force -Recurse -Verbose


Write-Output "Step 2, creating new folder and copy files into it"
Copy-Item "$siteRootWF\WildFlyGoldCopy" -Destination "$siteRootWF\$clonedWFFolder" -Recurse -Verbose


Write-Output "Step 3, Invoking cloned WildFly"
Start-Process -FilePath "$siteRootWF\$clonedWFFolder\bin\standalone.bat" -NoNewWindow -ArgumentList $(
    "-Djboss.http.port=$httpPlatformPort", 
    "-Djboss.server.log.dir=$homePath\LogFiles\$clonedWFFolder"
    )