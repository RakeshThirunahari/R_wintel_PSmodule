       
Param(
[string[]]$servernames,
[string]$path
)
Write-verbose " Script started"
Write-output " Hi Admin, Please find the server up-time mentioned below :"
if($path)
{
$Servernames = Get-content $path
}
           foreach ($Servername in $Servernames) 
          { 
            if ( Test-Connection -ComputerName $Servername -Count 1 -ErrorAction SilentlyContinue )  
          { 
	
            $wmi = get-wmiobject -class Win32_OperatingSystem -computer $Servername 
            $LBTime = $wmi.ConvertToDateTime($wmi.Lastbootuptime) 
            [TimeSpan]$uptime = New-TimeSpan $LBTime $(get-date) 
             
$upt = "$($uptime.days) Days $($uptime.hours) Hours $($uptime.minutes) Minutes $($uptime.seconds) Seconds"
            $out = new-object psobject -property @{
               computer = $Servername
               Uptime = $upt
}           
              $out          
          }
 
             else { 
                Write-warning "$Servername is not pinging" 
                  } 
               }