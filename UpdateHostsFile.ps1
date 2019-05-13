#Requirement is to comment out previous IP and domain name in hosts file and create a new line with the new IP and domain name.

$domainNameToBeUpdated = "test.com"
$newEntry = "127.0.0.1 newtest.com #updated 3/22/19"
$commentOutOldEntries = Get-Content $hostsFile | Select-String $domainNameToBeUpdated | Foreach-Object{ If($_ -Match $domainNameToBeUpdated ){'#' + $_ + ' #OLD Entry 1/1/16'} }
$hostsFile = "C:\Windows\System32\drivers\etc\hosts"
$oldEntries = Get-Content $hostsFile | Select-String $domainNameToBeUpdated
Write-host $oldEntries
foreach($oldEntry in $oldEntries)
{
foreach ($commentOutOldEntry in $commentOutOldEntries)
{
(Get-Content $hostsFile) -replace $oldEntry, "$commentOutOldEntry `n$newEntry" | Set-Content $hostsFile
}
}