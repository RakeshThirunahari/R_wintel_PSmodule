<# Script to extract Server Os and Powershell versions.
It will only report .Net version >= 4.0 and Powershell version >= 3.0
Author : THIRUNAHARI RAKESH
Mail: thrakesh.in.ibm.com
Make an Ansible folder on Desktop
Paste the list of servers in servers.txt one per one line.
Script will provide the report named versioninfo.csv in Ansible folder on desktop.
#>

If(!(Test-Path $Home\Desktop\Ansible))
{
mkdir $Home\Desktop\Ansible
}


Start-Transcript $Home\Desktop\Ansible\transcript.txt

$hklm = 2147483650
$key = "SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
$value = "Install"
$value2 = "version"
$dat = @()
$srv = Get-Content "$home\Desktop\servers.txt"

foreach ($s in $srv)
{
$data = Get-WmiObject -Class win32_operatingsystem -ComputerName $s | select Pscomputername,caption,CSDversion,OSArchitecture -ErrorAction Stop
 $wmi = get-wmiobject -list "StdRegProv" -namespace root\default -computername $s
 $data | Add-Member -NotePropertyName ".net installed" -NotePropertyValue "$(($wmi.GetDWORDValue($hklm,$key,$value)).uvalue)"
 $data | Add-Member -NotePropertyName "version" "$($wmi.GetStringValue($hklm,$key,$value2).sValue)"
 $wmi = $null
 $data 
 $dat += $data 
 }
 $dat | Export-Csv $home\Desktop\Ansible\versioninfo.csv