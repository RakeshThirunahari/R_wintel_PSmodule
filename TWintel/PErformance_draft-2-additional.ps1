$r=$r=Get-Counter -Counter "\Processor(_total)\% Processor Time","\Memory\Available MBytes","\Memory\Committed Bytes","\Paging File(_total)\% Usage","\LogicalDisk(_total)\Avg. Disk sec/Read","\LogicalDisk(_total)\Avg. Disk sec/Write","\LogicalDisk(_total)\Avg. Disk Queue Length","\LogicalDisk(_total)\Disk Transfers/sec","\Network Interface(*)\Bytes Sent/sec","\Network Interface(*)\Bytes Received/sec" -SampleInterval 2 -MaxSamples 2 | Select-Object -ExpandProperty countersamples | select @{n='Name';e={$_.path -ireplace [regex]::Escape("\\srv\"),""}},cookedvalue
$counters = $r.name | sort | Get-Unique
foreach ($counter in $counters)
{

@{$counter = ($r|Where-Object {$_.name -eq $counter}).cookedvalue | Measure-Object -Average | select -ExpandProperty average}

}