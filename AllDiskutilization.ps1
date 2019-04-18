$srvs = Get-Content C:\Users\a.thirunahari.rakesh.GLOBAL\Desktop\servers.txt
foreach($s in $srvs)
{
$Disks = Get-WmiObject -ComputerName $s -Class win32_logicaldisk -Filter "DriveType = 3"

 Foreach ($disk in $disks)
{

$Prop =[ordered] @{
    'Computername' = $s
    'Disk' = $disk | Select-Object -ExpandProperty DeviceID
    'Size(GB)' = [math]::Round(($disk.Size)/1GB,2)
    'Freespace(GB)' = [math]::Round(($disk.FreeSpace)/1GB,2)
    'FreespacePER' = [math]::Round(($Disk.FreeSpace/$Disk.Size)*100)
         }
$Obj = New-Object Psobject -Property $Prop
$obj 
$obj | Export-Csv -Path C:\Users\a.thirunahari.rakesh.GLOBAL\Desktop\diskinfo.csv -NoTypeInformation -Append
}
}


