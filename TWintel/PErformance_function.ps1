function oneline-2{
param (
[string[]]$computer
)
foreach ($comp in $computer){
"working on $comp "
$srv=hostname
$result=Get-Counter -ComputerName $comp -Counter "\Processor(_total)\% Processor Time","\Memory\Available MBytes","\Memory\Committed Bytes","\Paging File(_total)\% Usage","\LogicalDisk(_total)\Avg. Disk sec/Read","\LogicalDisk(_total)\Avg. Disk sec/Write","\LogicalDisk(_total)\Avg. Disk Queue Length","\LogicalDisk(_total)\Disk Transfers/sec","\Network Interface(*)\Bytes Sent/sec","\Network Interface(*)\Bytes Received/sec"| Select-Object -ExpandProperty countersamples | select @{n='Name';e={$_.path -ireplace [regex]::Escape("\\$srv\"),""}},cookedvalue
foreach ($t in $result)
{
$prop += [ordered]@{ $t.name = $t.CookedValue}
}
$Output = New-Object psobject -Property $prop
Clear-Variable -Name prop
$Output
}
}