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
function TGet-Performance
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
    Write-Verbose "Commandlet version 1.2"
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

Workflow TGet-test
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Accepts multiple computer names even through pipeline
        [Parameter(Mandatory=$false,
                
                   Position=0
                   )]
        [string[]]$Computername,
        # Enables continuous mode for cmdlet
        [switch]$Monitor

    )
    Write-Verbose "Commandlet version 1.2"
    Write-Output "You are using custom cmdlet written by Thirunahari Rakesh, Be cautious! " 
        Write-Verbose "$Computername"
    if(!$Computername)
    {
    $Computername = hostname
    }
        foreach ($hostname in $Computername)
        {

        $memvar = 'X'
        $memper = 'X'
        $Cpuper = 'X'
        Write-Verbose " Working on $hostname $memvar $memper $Cpuper"
            # Memory calcuulation block
            Write-Verbose "mem cal"
            $memvar = Get-WmiObject win32_operatingsystem 
            $memper = 100-([math]::Round(($memvar.freephysicalmemory/$memvar.TotalVisibleMemorySize)*100,0))
           
            # Cpu calculation block
             Write-Verbose "cpu cal"
           $Cpuper = Get-Counter -Counter '\processor(_total)\% Processor Time'| Select-Object -ExpandProperty countersamples | Select-Object -ExpandProperty "cookedvalue"
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
        
   
   
   
    Write-Output "Completed succesfully" 
   }
   }