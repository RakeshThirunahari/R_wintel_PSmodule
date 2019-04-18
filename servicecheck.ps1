function Report-scvstatus
{
$sucess = @()
$Failed = @()
$p = 0
$servers = Get-Content $home\desktop\servers.txt

If(!(Test-Path $home\desktop\services_report))
{
mkdir $home\desktop\services_report
}

foreach($s in $servers)
{
Write-Progress -Activity " Progress $($p+1) of $($servers.count) " -Status "$($p*100/$($servers.count)) % Complete:" -PercentComplete $($p*100/$($servers.count)) -CurrentOperation "Working on $s ::::::: Successfull=$($sucess.Count):::::Failed=$($Failed.Count)"
try {
$services = Get-Service -ComputerName $s -ErrorAction Stop| select Name,status,machinename 
$services | Export-Csv $home\desktop\services_report\$s.csv
$sucess += $s
}
catch { $Failed += $s }

$p += 1
}
$Failed | Out-File $home\desktop\services_report\Prepatch_Failure.txt
}

function Compare-scvstatus
{
$sucess = @()
$Failed = @()
$p = 0
$servers = Get-Content $home\desktop\servers.txt

foreach($s in $servers)
{
Write-Progress -Activity " Progress $($p+1) of $($servers.count) " -Status "$($p*100/$($servers.count)) % Complete:" -PercentComplete $($p*100/$($servers.count)) -CurrentOperation "Working on $s ::::::: Successfull=$($sucess.Count):::::Failed=$($Failed.Count)"
try{
$services = Get-Service -ComputerName $s -ErrorAction Stop | select Name,status,machinename
$scvcsv = Import-Csv $home\desktop\services_report\$s.csv
$comp = Compare-Object -ReferenceObject $scvcsv -DifferenceObject $services -Property name,status,machinename | select machinename,name,status,SideIndicator
if(!$comp)
{
$res = New-Object psobject -Property @{machinename = "$s"; Name = "All Good"; status= "All Good";SideIndicator = "All Good"  }
$res |select machinename,name,status,SideIndicator | Export-Csv -Path $home\desktop\services_report\report.csv -NoTypeInformation -Append
}
else
{
$comp | Export-Csv -Path $home\desktop\services_report\report.csv -NoTypeInformation -Append
}
$sucess += $s
}
catch  { $Failed += $s}
$p += 1
}
$Failed | Out-File $home\desktop\services_report\Postpatch_Failure.txt
}

Function Recover-scvstatus
{

$p = 0
$sucess = @()
$Failed = @()
$report = Import-Csv $home\Desktop\services_report\report.csv  | Where-Object -Property sideindicator -like "<="

foreach ($r in $report)
{
Write-Progress -Activity " Progress $($p+1) of $($report.count) " -Status "$($p*100/$($report.count)) % Complete:" -PercentComplete $($p*100/$($report.count)) -CurrentOperation "Working on $r ::::::: Successfull=$($sucess.Count):::::Failed=$($Failed.Count)"

if($r.status -like "Running"){
try {

$r | Get-Service -ComputerName $r.machinename -ErrorAction Stop | Start-Service
$sucess += $r
}
catch 
{
$Failed += $r
$Failed |  Out-File $home\desktop\services_report\Recovery_Failure.txt
}
}
$p += 1
}


}


