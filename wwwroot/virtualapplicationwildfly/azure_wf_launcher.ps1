$httpPlatformPort = (get-item env:"HTTP_PLATFORM_PORT").Value
$homePath = (get-item env:"HOME").Value

$siteRootWF = "$homePath\site\wwwroot\virtualapplicationwildfly"
$clonedWFFolder = "WF_$($env:COMPUTERNAME)_$(Get-Date -format 'yyyyMMdd_HHmmss')_$($httpPlatformPort)"

Write-Output "Step 1, clean up old folders"
Get-ChildItem -Path $siteRootWF -Filter "WF_$($env:COMPUTERNAME)_*" -Directory | 
                            sort -Property CreationTime -Descending | 
                            select -Skip 1 | 
                            Remove-Item -Recurse -Force

Write-Output "Step 2, creating new folder and copy files into it"
Copy-Item "$siteRootWF\WildFlyGoldCopy\standalone" -Destination "$siteRootWF\$clonedWFFolder\standalone" -Recurse


Write-Output "Step 3, Invoking cloned WildFly"
Start-Process -FilePath "$siteRootWF\WildFlyGoldCopy\bin\standalone.bat" -NoNewWindow -ArgumentList $(
    "-Djboss.http.port=$httpPlatformPort", 
    "-Djboss.server.log.dir=$homePath\LogFiles\$clonedWFFolder",
    "-Djboss.controller.temp.dir=$siteRootWF\$clonedWFFolder\controller",
    "-Djboss.server.temp.dir=$siteRootWF\$clonedWFFolder\temp",
    "-Djboss.server.data.dir=$siteRootWF\$clonedWFFolder\data",
    "-Djboss.server.deploy.dir=$siteRootWF\$clonedWFFolder\deploy",
    "-Djboss.server.base.dir=$siteRootWF\$clonedWFFolder\standalone",
    "-Djboss.home.dir=$siteRootWF\WildFlyGoldCopy\standalone"
    )
