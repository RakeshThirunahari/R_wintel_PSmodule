function Remove-BigFix {

  $srvs = Get-Content $home\Desktop\server.txt
   $p = 0
  $s = @()
  $f = @()
foreach ($srv in $srvs)
{
Write-Progress -Activity " Progress $($p+1) of $($srvs.count) " -Status "$($p*100/$($srvs.count)) % Complete:" -PercentComplete $($p*100/$($srvs.count)) -CurrentOperation "Working on $srv :: Successful= $($s.Count), Failed= $($f.Count)"
Try { 
Invoke-Command -ComputerName $srv -ScriptBlock { Write-Output "working on $env:COMPUTERNAME"
$uninstall32 = gci "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "IBM BigFix Client" } | select UninstallString
$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "IBM BigFix Client" } | select UninstallString
if ($uninstall32 -or$uninstall64)
{
Get-Service BESClient | Stop-Service -force

if ($uninstall64) {
$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall64 = $uninstall64.Trim()
Write "Uninstalling..."
start-process "msiexec.exe" -arg "/X $uninstall64 /qb /norestart" -Wait
}

if ($uninstall32) {
$uninstall32 = $uninstall32.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall32 = $uninstall32.Trim()
Write "Uninstalling..."

start-process "msiexec.exe" -arg "/x $uninstall32 /qb /norestart" -Wait 
}

Remove-Item "HKLM:\SOFTWARE\Wow6432Node\BigFix\EnterpriseClient\Settings\Client" -Force -Recurse -Confirm:$false

}
} -ErrorAction Stop
$s += $srv
} 
catch {
write "Remove attempt failed "
$f += $srv
    }
       
}
"###################################Successful on servers##########################################" | Out-File $home\desktop\result.txt -Append

$s | Out-File $home\desktop\result.txt -Append

"#######################################Failed oin servers###############################################" | Out-File $home\desktop\result.txt -Append
$f | Out-File $home\desktop\result.txt -Append

}


Function Install-Bigfix
{

$srvs = Get-Content $home\Desktop\srv1.txt

foreach ($srv in $srvs)
{

Try {
Copy-Item -Path "C:\Bixfix\BigTemp" -Destination "\\$srv\c$\" -Recurse
Invoke-Command -ComputerName $srv -ScriptBlock {
Write-Output "working on $env:COMPUTERNAME"
 Start-Process C:\BigTemp\BigFix-BES-Client-9.2.6.94.exe  -args "/s /v /passive" -wait -NoNewWindow
 Remove-Item -Path "C:\BigTemp" -Recurse -force
} -ErrorAction Stop -ErrorVariable installerror

}
Catch 
{
 foreach ($e in $installerror)
    {

   $prop = [ordered]@{
    Server = $e.ErrorRecord.TargetObject
    Error = $e.ErrorRecord.FullyQualifiedErrorId
    }
    $errorout = New-object psobject -Property $prop 
    $errorout
    }


}
}
}

