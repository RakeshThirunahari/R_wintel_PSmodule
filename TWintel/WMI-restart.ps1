workflow reset_wmi 
{ 
  InlineScript {
    # save list of running dependants
    HOSTNAME 
    $dependencies = get-service winmgmt -DependentServices | Where-Object{ $_.Status -eq "Running" } 
 
    # force services to stop 
    Stop-Service "Winmgmt" -force -ErrorAction Ignore 
    Stop-Service "wmiApSrv" -force -ErrorAction Ignore 
 
    # kill Wmi processes if any still running 
    Get-Process "WmiPrvSE" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue 
    Get-Process "WmiApSrv" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
 
    # restart services 
    Start-Service "Winmgmt"  
    Start-Service "wmiApSrv" 
    $dependencies | Start-Service -ErrorAction Ignore 
   
} }
 