
$pdc = (Get-ADDomain).PDCEmulator
Get-WinEvent -ComputerName $pdc -FilterHashtable @{Logname='Security'; ID= '4740'} -OutVariable logs
$outob = @()
$outob2 = @()
foreach ($log in $logs)
{
$prop = [ordered]@{
  Account = $log.properties[0].value
  LockOutLocation = $log.properties[1].value
  
 }
 $outob += New-Object psobject -Property $prop
}
for ($i = 0; $i -lt $outob.count ; $i++)
 {
 $outob2 += $outob[$i].psobject.copy()

 for ($j = 0; $j -lt $outob.count ; $j++)
 {

 if($outob[$i].account.Equals($outob[$j].account))
 {

 if( $outob2[$i].LockOutLocation -notmatch $outob[$j].LockOutLocation)
 {
 $outob2[$i].LockOutLocation += ",$($outob[$j].LockOutLocation)"
 }
 }
   }
              
 }
$table = $outob2 | Sort-Object -Property account -Unique | ConvertTo-Html -Fragment
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
Hello,<br>
Account lockout report. Dated : $(Get-date) </br>
</p>
$table
<p style= font-size:60% > NOTE: Auto Alert. This is a script generated report. Author : THIRUNAHARI RAKESH
</p>
</body>
</html>"
$hbody | Out-File 'C:\Program Files\Wintel_PSmodules\Scripts\Outfiles\lockout.csv'

#remove pound sign (#) from belo line to start message service of script.
Send-MailMessage -from "thirunahari.rakesh@woodgroup.com" -To "imi_wintel_woodgroup@wwpdl.vnet.ibm.com","iamhelp@woodplc.com"  -Cc "thrakesh@in.ibm.com","bilgeorg@in.ibm.com" -subject "Account Lockout report - WOOD" -BodyAsHTML -body "$hbody" -priority High -smtpServer "smtpncsa.woodgroup.com"
