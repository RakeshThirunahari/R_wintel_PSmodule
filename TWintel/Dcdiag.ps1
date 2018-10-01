
function Get-Dcdiag
{
 [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Computername
       
    )
    $rawdiag = Dcdiag /s:$Computername
foreach ($diag in $rawdiag)
{

switch -Regex ($diag) 
{
 "passed test | failed test" {$r = $diag.Replace('.','').trim().split("")
 $prop = [ordered]@{
 "Test Item" = $r[0]
 "Test" = $r[-1]
 "Resullt" = $r[1]
 }
 $out = New-Object psobject -Property $prop
 $out
 } 
  
 }
}
}