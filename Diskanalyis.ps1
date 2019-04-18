Start-Transcript -Path C:\Users\a.thirunahari.rakesh.GLOBAL\Desktop\Diskana\translog.txt
$srvs = Get-Content C:\Users\a.thirunahari.rakesh.GLOBAL\Desktop\servers.txt
$driveinf = @{}
foreach($s in $srvs)
{
$driveinf = $null
$report = $null
$Disks = Get-WmiObject -ComputerName $s -Class win32_logicaldisk -Filter "DriveType = 3"

 Foreach ($disk in $disks)
{
$free = [math]::Round(($Disk.FreeSpace/$Disk.Size)*100)
$Prop =[ordered] @{ 
    #'Computername' = $s
    #'Disk' = $disk | Select-Object -ExpandProperty DeviceID
    #'Size(GB)' = [math]::Round(($disk.Size)/1GB,2)
    #'Freespace(GB)' = [math]::Round(($disk.FreeSpace)/1GB,2)
    "FreespacePER $($disk.DeviceID)" = [math]::Round(($Disk.FreeSpace/$Disk.Size)*100)
         }
#$Obj = New-Object Psobject -Property $Prop
$driveinf += $Prop

if ($free -le 20) 
{
"Working on $($disk.deviceid)"
$report1 = Invoke-Command -ComputerName $s -ArgumentList $($disk.deviceid) -ScriptBlock {
$env:COMPUTERNAME
$out = @()
$args

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

$files = Get-ChildItem $args[0] -Force | where {!$_.PSIsContainer} | sort -Property Length -Descending | select -First 5

foreach($file in $files)
{ 
$pro1 = @{
"Folder" = $file.FullName
"Size(GB)" = [math]::round($file.Length/ 1GB,2)
}
$out += New-Object psobject -Property $pro1 
}

$folders = Get-ChildItem $args[0] -Force | where {$_.PSIsContainer} 

foreach($folder in $folders)
{
$Size =[math]::round(((Get-ChildItem $Folder.FullName -Recurse | Measure-Object -Property Length -Sum ).Sum / 1GB),2)
$pro = @{
"Folder" = $folder.FullName
"Size(GB)" = $Size
}
$out += New-Object psobject -Property $pro

}
$out | Sort-Object -Property "size(GB)" -Descending| select -First 7 | ConvertTo-Html -Fragment
} 
$report += $report1
}

}

$Objt = New-Object Psobject -Property $driveinf
$obj = $Objt | ConvertTo-Html -Fragment
if($report)
{
$hbody = " <html>
<head>
<style>
table, th, td {
    border: 1px solid black;
}
th {background-color:gold;}
</style>
</head>
<body> 
<p>
Hello,
<br>
More details for the Drive
<br>
$obj
Top  space consumption folders</br>
</p>

$report
<br>

</body>
</html>
"
"Generating HTML report"
$hbody | out-file "C:\Users\a.thirunahari.rakesh.GLOBAL\Desktop\Diskana\$s.html"
}
}









