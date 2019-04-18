$OutPath = "C:\Users\a.thirunahari.rakesh.GLOBAL\Desktop\Ad repot"
$srv = Get-Content C:\Users\a.thirunahari.rakesh.GLOBAL\Desktop\server.txt

$success = @()
$failed = @()
$p = 0
foreach($s in $srv)
{

$out = $null
Write-Progress -Activity "Progress $($p+1) of $($srv.Count) servers" -Status "$($p*100/$($srv.count)) % Complete:" -PercentComplete $($p*100/$($srv.count)) -CurrentOperation "Working on $s ::::::: Successfull=$($success.Count):::::Failed=$($Failed.Count)"
try {
$out = icm -ComputerName $s -ScriptBlock {

$Cinfo = Get-WmiObject -Class win32_logicaldisk -Filter "DeviceId = 'C:'"
$sqlfolders = Get-childItem 'c:\','C:\Program Files','C:\Program Files (x86)' -ErrorAction SilentlyContinue -Filter *sql*
if ($sqlfolders) 
{
foreach($folder in $sqlfolders)
{
$prop = @{
CSizeinMB = [math]::Round(($Cinfo.Size / 1MB),2)
CdriveFreeSpace = [math]::Round(($Cinfo.FreeSpace/$Cinfo.Size)*100)
File = $folder.FullName
FileSizeinMB = [math]::round(((Get-ChildItem $Folder.FullName -Recurse | Measure-Object -Property Length -Sum ).Sum / 1MB),2)
}
$icout = New-Object psobject -Property $prop
$icout
}
}
else
{
$prop = @{
CSizeinMB = [math]::Round(($Cinfo.Size / 1MB),2)
CdriveFreeSpace = [math]::Round(($Cinfo.FreeSpace/$Cinfo.Size)*100)
File = "No SQl Folder found"
FileSizeinMB = "No SQl Folder found"
}
$icout = New-Object psobject -Property $prop
$icout
}

} -ErrorAction Stop
$out | select PSComputerName,CSizeinMB,CdriveFreeSpace,File,FileSizeinMB | Export-Csv "$OutPath\SQLreport.csv" -NoTypeInformation -Append
$success += $s
$s | Out-File $OutPath\SQLsuccess.txt -Append
}
catch 
{
"Failed to fetch for $s"
$failed += $s
$s | Out-File $OutPath\SQLfailed.txt -Append
}
$p += 1
}