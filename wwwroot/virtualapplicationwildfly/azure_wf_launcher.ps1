$httpPlatformPort = (get-item env:"HTTP_PLATFORM_PORT").Value
$homePath = (get-item env:"HOME").Value
$originalWFFolder = "WildFlyGoldCopy"


Write-Output "Step 1, clean up old folders"

$siteRootWF = "$homePath\site\wwwroot\virtualapplicationwildfly"
$oldDirToDeleteFilter = "WF_$($env:COMPUTERNAME)_*"

Write-Output "Checking for old files that match pattern: $oldDirToDeleteFilter"

$sortedFolders = Get-ChildItem -Path $siteRootWF -Filter $oldDirToDeleteFilter -Directory | sort -Property CreationTime -Descending

if($sortedFolders.Count -gt 0) {
    Write-Output "Sorted folders: $sortedFolders"

    Write-Output "Deleting all folders that match pattern, apart from $($sortedFolders[0].FullName)"

    for($index = 1; $index -lt $sortedFolders.Length; $index++) {
        Remove-Item -Path $sortedFolders[$index].FullName -Force -Recurse
        Write-Output "Removed folder $($sortedFolders[$index].FullName)"
    }
} else {
    Write-Output "There is nothing to delete"
}


Write-Output "Step 2, creating new folder and  copy files into it"

$dateAndTimeStamp = Get-Date -format 'yyyyMMdd_HHmmss'
$clonedWFFolder = "WF_$($env:COMPUTERNAME)_$($dateAndTimeStamp)_$($httpPlatformPort)"
Write-Output "New WF folder name $clonedWFFolder"

Copy-Item "$siteRootWF\$originalWFFolder" -Destination "$siteRootWF\$clonedWFFolder" -Recurse


Write-Output "Step 3, Invoking cloned WildFly"
$args = $(
    "-Djboss.http.port=$httpPlatformPort", 
    "-Djboss.server.log.dir=$homePath\LogFiles\$clonedWFFolder"
    )


Start-Process -FilePath "$siteRootWF\$clonedWFFolder\bin\standalone.bat" -NoNewWindow -ArgumentList $args 

Write-Output "Exiting Azure_WF_Launcher"


