#Requirement was to get archive folders with zip files for the year of 2018 and to copy the
#contents in the zip file and place them in another directory with the same name.
#If any contents in the zip files are also in the first half of 2018, they should be deleted.

$fileNames = Get-ChildItem \\locationOfArchives\ | select name
foreach ($fileName in $fileNames)
{
	$fileName = $fileName.Name
	Get-ChildItem \\locationOfArchives\$fileName | 
    where-object {($_.LastWriteTime -ge '1/1/2018') -and ($_.LastWriteTime -le '1/1/2019')} | 
    Foreach-Object {
        $zipName = $_.Name
        write-host $fileName + "        " +      $_.LastWriteTime + "        " +   $zipName   
        Expand-Archive -LiteralPath "\\locationOfArchives\$fileName\$zipName" -DestinationPath "\\destinationToPutZipFileContents\$fileName"
        Get-ChildItem "\\destinationToPutZipFileContents\$fileName\*.tlg*" | where-object {($_.LastWriteTime -ge '1/01/2018')} | Remove-Item 
        Get-ChildItem "\\destinationToPutZipFileContents\$fileName\*.tlg*" | where-object {($_.LastWriteTime -le '6/1/2018')} | Remove-Item
    }
}

#If you want to unzip just 1 folder
#$fileName = 'testFileName'    
#Get-ChildItem \\locationOfArchives\$fileName | 
#   where-object {($_.LastWriteTime -ge '1/1/2018') -and ($_.LastWriteTime -le '1/15/2019')} | Foreach-Object {
#            $zipName = $_.Name
#            write-host $fileName + "        " +      $_.LastWriteTime + "        " +   $zipName   
#            Expand-Archive -LiteralPath "\\locationOfArchives\$fileName\$zipName" -DestinationPath "\\destinationToPutZipFileContents\$fileName"
#            Get-ChildItem "\\destinationToPutZipFileContents\$fileName\*.tlg*" | where-object {($_.LastWriteTime -ge '1/01/2018')} | Remove-Item 
#            Get-ChildItem "\\destinationToPutZipFileContents\$fileName\*.tlg*" | where-object {($_.LastWriteTime -le '6/1/2018')} | Remove-Item
#        }

#get number of transferred tlg files in each directory
#$fileNames = Get-ChildItem \\locationOfArchives\ | select name | Sort-Object -Property name
#foreach ($fileName in $fileNames)
#{
#	$fileName = $fileName.Name
#    write-host $fileName +  "                " + (Get-ChildItem "\\destinationToPutZipFileContents\$fileName\*.tlg*" | Measure-Object).Count
#}


