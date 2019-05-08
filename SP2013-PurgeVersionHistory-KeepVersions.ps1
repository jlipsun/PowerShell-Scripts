$web = get-spweb "SP2013-SiteCollection-URL"
$doclib = $web.Lists["SP2013-List"]
$startdate = get-date
write-host "Started on: " $startdate

$doclib.Items | % {

$item = $_
$itemName = $item.Name

	#First, they want to purge data older than a certain date (let�s say 6 months old now, but this may change)
	for($i=$item.Versions.Count-1; $i -gt 0; $i--)
	{
			$version = $item.Versions[$i]
			[datetime]$versionDate = ($version.Created -split " ")[0]
			[datetime]$dateDifference = ((get-date).AddMonths(-6) -split " ")[0]
		
			#To test a single existing file.
			#if (($itemName -eq "test.docx")) 
			#{
				if ($versionDate -lt $dateDifference) 
				{	
					write-host "ID: $($version.VersionLabel) - File: $itemName - Version Date: $versionDate"
					write-host "Deleting"
					$version.Delete()
					write-host "Deleted"
				}
			#}
	}	
}


#For any versions that remain, they would want to keep only X number of versions (let�s say the last 20 versions)
$doclib.MajorVersionLimit = 20
$doclib.Update()

$enddate = get-date
write-host "Ended on: " $enddate
