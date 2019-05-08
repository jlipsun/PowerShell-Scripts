#In SharePoint 2013, you can enable version history and see all of the different versions of the documents. 
#I had a request to first purge version history older than 6 months and for any versions that remain, 
#they would want to keep only 20 versions. Since there were many documents in the library, I created this script to run once and 
#to meet this requirement.

$web = get-spweb "SP2013-SiteCollection-URL"
$doclib = $web.Lists["SP2013-List"]
$startdate = get-date
write-host "Started on: " $startdate

$doclib.Items | % {

$item = $_
$itemName = $item.Name

	#First, they want to purge data older than a certain date (lets say 6 months old now, but this may change)
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

#For any versions that remain, they would want to keep only X number of versions (lets say the last 20 versions)
$doclib.MajorVersionLimit = 20
$doclib.Update()

$enddate = get-date
write-host "Ended on: " $enddate
