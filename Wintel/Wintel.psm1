<#
.Synopsis
   Commandlet to kick-off disconnected user sessions
.DESCRIPTION
   This will logoff the disconnected user sessisons from specified servers, if no server specified it will logoff disconnected user sessions from local machine.
.EXAMPLE
   Logoff-Discusers
   This will disconnected sessions in local computer user select the sessions need to be removed
.EXAMPLE 
   Logoff-Discusers -Computername ep-ts-ibm-01

   This will logoff disconnected users from ep-ts-ibm-01 ofter user select the sessions need to removed
.EXAMPLE
   Logoff-Discusers -Computername ep-ts-ibm-01 -Noselect

   This will logoff disconnected users from ep-ts-ibm-01, In this case it will not ask user to select sessions need to be removed
.INPUTS
   -computername
   will accept pipe line input 
   Will accept multiple strings

.FUNCTIONALITY
   Logoff Disconnected user sessions on local or remote computers
#>
function Logoff-Discusers
{
    [CmdletBinding(#SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  ConfirmImpact='High')]
    [OutputType([String])]
    Param
    (
        # It will take mulitiple computernames to operate on
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0)]
        [String[]]$Computername,
        # If not specified command let will ask for the user selection to logoff user, if specified will not ask any confirmation loggs-off all disconnected user sessions.
        [switch]$Noselect
        )


    Begin
    {
    Write-Host "You are using custom cmdlet written by Thirunahari Rakesh, Be cautious!" -ForegroundColor blue -BackgroundColor White
    if(!$Computername)
    {
   $Computername = hostname
    }
    }
    Process
    {
        #if ($pscmdlet.ShouldProces("$computer","Kick off disconnected user"))
        foreach ($comp in $Computername)
        {

        $Discusers1 = query user /server:$comp | Select-String disc
        if (!$Noselect)
        {
        $Discusers = $Discusers1 | select line |Out-GridView -OutputMode Multiple -Title "Select users need to be logged off for $comp"
        }
        else { $Discusers = $Discusers1 }
        if (!$Discusers)
        {
        Write-Output " NoDisconnected user sessions available for $comp"
        }
        else
        {
        foreach ($discuser in $Discusers)
      
        {
        $user = ($Discuser -split ' +')
        
        Write-Warning " logging off user $($user[1]) from $comp"
        logoff $user[2] /server:$comp
        }
        }
    }
    }
    End
    {
    
    }
}

<#
.Synopsis
   This will give memory and Cpu usage statistics
.DESCRIPTION
   This will give memory and Cpu usage statistics if specified for a remote computer if not loacl computer
.EXAMPLE 
Get-Performance
If nothing specified it will give local computer statistics
Computername                               MemoryLoad                   Cpuload
------------                               ----------                   -------
WP-TS-IBM-01                                       38                         1
.EXAMPLE
Get-Performence -Computer remotecomp
It will produce remotecomp cpu and memeory usage
.Example
Get-content ./srv.txt | Get-performence
It will take servers form srv.txt and produce memory and cpu usage for all servers.
.Example
Get-Performence -monitor
Monitor will enable to run the commond continuously for every 30 seconds on local or list of computers

#>
function Get-Performance
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Accepts multiple computer names even through pipeline
        [Parameter(Mandatory=$false,
                
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,
                   ValueFromPipeline=$true)]
        [string[]]$Computername,
        # Enables continuous mode for cmdlet
        [switch]$Monitor

    )

    Begin
    {
    Write-Host "You are using custom cmdlet written by Thirunahari Rakesh, Be cautious! " -ForegroundColor blue -BackgroundColor White
    Write-Verbose "$Computername"
    if(!$Computername)
    {
    $Computername = hostname
    }
    }
    Process
    {
    Do
    {
        foreach ($hostname in $Computername)
        {

        $memvar = 'X'
        $memper = 'X'
        $Cpuper = 'X'
        Write-Verbose " Working on $hostname $memvar $memper $Cpuper"
            # Memory calcuulation block
            Write-Verbose "mem cal"
            $memvar = Get-WmiObject win32_operatingsystem -ComputerName $hostname
           
            $memper = 100-([math]::Round(($memvar.freephysicalmemory/$memvar.TotalVisibleMemorySize)*100,0))
           
            # Cpu calculation block
             Write-Verbose "cpu cal"
           $Cpuper = Get-Counter -Counter '\processor(_total)\% Processor Time' -ComputerName $hostname -ErrorAction SilentlyContinue| Select-Object -ExpandProperty countersamples | Select-Object -ExpandProperty cookedvalue
            if($Cpuper){ $CpuperR=[math]::Round($Cpuper,0)}
              # outputing objet
    Write-Verbose " formatting out"
            $prop =[ordered] @{
                 Computername = $hostname
                 MemoryLoad = $memper
                 CpuloadRounded = $CpuperR
                 cpu = $Cpuper                   
                    }
            $OUT =New-Object psobject -Property $prop
            Write-Verbose "output"
            $out
        
    }
    if($Monitor){
    Write-Verbose "wait"
    Start-Sleep -Seconds 0
   
    }

    }
    While($Monitor)
    }
    End
    {
    Write-Host "Completed succesfully" -ForegroundColor blue -BackgroundColor White
    }
}