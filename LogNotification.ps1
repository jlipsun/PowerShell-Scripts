#Requirement was to check specific errors in logs and notify the team when that specific error occurred.

$lineNumberArray = @()

$lineNumberArray = get-content "D:\Logfile.txt" | Select-String -pattern "ERROR123" | select linenumber

[int]$lineNumberFromFile = Get-Content "D:\LineNumber.txt"
[int]$lineNumberFromLogFile = $lineNumberArray[$lineNumberArray.length-1].LineNumber

if($lineNumberFromFile -lt $lineNumberFromLogFile){
$lineNumberFromLogFile | out-file -filepath "D:\LineNumber.txt"
& "D:\emailLogIssue.cmd"
}