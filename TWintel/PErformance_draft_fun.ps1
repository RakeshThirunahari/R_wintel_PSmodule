
function fun-health{
Get-Counter -Counter "\Processor(_total)\% Processor Time" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
Get-Counter -Counter "\Memory\Available MBytes" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
Get-Counter -Counter "\Memory\Committed Bytes" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
Get-Counter -Counter "\Paging File(_total)\% Usage" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
Get-Counter -Counter "\LogicalDisk(_total)\Avg. Disk sec/Read"  | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
Get-Counter -Counter "\LogicalDisk(_total)\Avg. Disk sec/Write"  | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
Get-Counter -Counter "\LogicalDisk(_total)\Avg. Disk Queue Length" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
Get-Counter -Counter "\LogicalDisk(_total)\Disk Transfers/sec" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
Get-Counter -Counter "\Network Interface(*)\Bytes Sent/sec" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
Get-Counter -Counter "\Network Interface(*)\Bytes Received/sec" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
}
