	
$String = "SNMP"
$Domains =  Get-ADForest | select -ExpandProperty domains
$mp = 0

 foreach ($domain in $Domains)
 {
 Write-Progress -Id 1 -Activity " Progress $($mp+1) of $($Domains.count) " -Status "$($mp*100/$($Domains.count)) % Complete:" -PercentComplete $($mp*100/$($Domains.count)) -CurrentOperation "Working on $Domain" # ::::::: Successfull=$($sucess.Count):::::Failed=$($Failed.Count)"
$NearestDC = (Get-ADDomainController -DomainName $domain -Discover -NextClosestSite).Name

#Get a list of GPOs from the domain
$GPOs = Get-GPO -All -Domain $Domain -Server $NearestDC  | sort DisplayName
 $sp = 0
#Go through each Object and check its XML against $String
Foreach ($GPO in $GPOs)  {
 
  Write-Progress -ParentId 1 -Activity " Progress $($sp+1) of $($GPOs.count) " -Status "$($sp*100/$($GPOs.count)) % Complete:" -PercentComplete $($sp*100/$($GPOs.count)) -CurrentOperation "Working on $GPO.DisplayName" # ::::::: Successfull=$($sucess.Count):::::Failed=$($Failed.Count)"
 
  
  #Get Current GPO Report (XML)
  $CurrentGPOReport = Get-GPOReport -Guid $GPO.Id -ReportType Xml -Domain $Domain #-Server $NearestDC
  
  If ($CurrentGPOReport -match $String)  {

  $gpo | select * | Export-Csv 'C:\Users\a.thirunahari.rakesh.GLOBAL\desktop\Ad repot\gporeport.csv'-NoTypeInformation -Append
  
  }
 $sp += 1 
}

$mp += 1
}


$report.GPO.Computer.ExtensionData.extension.policy.listbox.value.element