<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this workflow
.EXAMPLE
   Another example of how to use this workflow
.INPUTS
   Inputs to this workflow (if any)
.OUTPUTS
   Output from this workflow (if any)
.NOTES
   General notes
.FUNCTIONALITY
   The functionality that best describes this workflow
#>
workflow Get-OSHealth 
{
parallel{

#InlineScript{$pr=Get-Counter -Counter "\Processor(_total)\% Processor Time" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
#$obj0 = New-Object psobject -Property @{Proc= $pr};return $obj0}
InlineScript{$ma=Get-Counter -Counter "\Memory\Available MBytes" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue
$obj1 = New-Object psobject -Property @{mem = $ma};return $obj1}
#InlineScript{Get-Counter -Counter "\Memory\Committed Bytes" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue}
#InlineScript{Get-Counter -Counter "\Paging File(_total)\% Usage" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue}
#InlineScript{Get-Counter -Counter "\LogicalDisk(_total)\Avg. Disk sec/Read"  | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue}
#InlineScript{Get-Counter -Counter "\LogicalDisk(_total)\Avg. Disk sec/Write"  | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue}
#InlineScript{Get-Counter -Counter "\LogicalDisk(_total)\Avg. Disk Queue Length" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue}
#InlineScript{Get-Counter -Counter "\LogicalDisk(_total)\Disk Transfers/sec" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue}
#InlineScript{Get-Counter -Counter "\Network Interface(*)\Bytes Sent/sec" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue}
#InlineScript{Get-Counter -Counter "\Network Interface(*)\Bytes Received/sec" | Select-Object -ExpandProperty countersamples| Select-Object -ExpandProperty cookedvalue}
}
$tets
}

