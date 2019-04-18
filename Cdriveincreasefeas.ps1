
# Add-PSSnapin VMware.VimAutomation.Core
# C:\"Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"
 
#VC report

Function Get-FromVMinfo

{

param (
[Parameter(Mandatory=$true)]
 [string]$Vcenter,
 [string]$VM

)
Connect-VIServer $vc | Out-Null

$HD = (Get-Vm $VM | Get-HardDisk | select * | where -Property name -like "Hard disk 1")

$DStore = Get-Datastore -Name $hd.Filename.Split(']')[0].trim('[')

 [ordered]@{
    
    VHD = $hd.Filename
    VHDDisk = $hd.Name
    VHDSizeGB = $hd.CapacityGB
    DataStore = $DStore.Name
    DataStoreSizeGB = $DStore.CapacityGB
    DataStoreFreeSpaceGB = $DStore.FreeSpaceGB
    DataStoreFreeSpacePER = [math]::Round((($DStore.FreeSpaceGB/$DStore.CapacityGB)*100),1)
} 

}

# OS side Report

Function Get-CdriveInfo 

{
  Param
    (
        
        [Parameter(Mandatory=$true)]
        $VM
       
    )

 $Pdisk = Get-WmiObject Win32_DiskDrive -ComputerName $VM |  where deviceID  -EQ  "\\.\PHYSICALDRIVE0"

  $Query = "ASSOCIATORS OF " +
                "{Win32_DiskDrive.DeviceID='$($Pdisk.DeviceID)'} " +
                "WHERE AssocClass = Win32_DiskDriveToDiskPartition"
  $partitions = Get-WmiObject -Query $Query -ComputerName $VM
  
  foreach ($partition in $partitions) 
  {  
    $drives = "ASSOCIATORS OF " +
              "{Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} " +
              "WHERE AssocClass = Win32_LogicalDiskToPartition"
    Get-WmiObject -Query $drives -ComputerName $VM | % {
      
       [ordered] @{
        DriveLetter = $_.DeviceID
        VolumeName  = $_.VolumeName
        VolumeSizeGB        = $_.Size/1GB
        VolumeFreeSpaceGB   = $_.FreeSpace/1GB
        VolumeFreeSpacePer  = [math]::Round((($_.freeSpace/$_.Size)*100),1)
        Disk        = $Pdisk.DeviceID
        DiskSizeGB    = $Pdisk.Size / 1GB
        DiskModel   = $Pdisk.Model
        Partition   = $partition.Name
        RawSizeGB    = $partition.Size / 1GB
        PartitionIndex = $partition.index
        PartitionCount = $Pdisk.Partitions
       
      }
    }
  }
  }


$srvs = Import-Csv $HOME\desktop\servers.csv
$p = 1
foreach ($srv in $srvs)
{
Clear-Variable Cdrive
Clear-Variable Cvdsik
Write-Progress -id 1 -Activity " Evaluating  $($p) of $($srvs.count) " -Status "$($p*100/$($srvs.count)) % Complete:" -PercentComplete $($p*100/$($srvs.count)) -CurrentOperation "Working on $($srv.server)"

$e = [pscustomobject][ordered] @{ Server = $srv.server; Ccheck = ''; Vcheck = '' } 
try {

Write-Progress -ParentId 1 -Activity "Evaluating C Drive details OS level"
$Cdrive = Get-CdriveInfo -VM $srv.Server -ErrorAction Stop
$e.Ccheck = "Successful"
}

Catch {

$e.Ccheck = "Failed"
 
}

try {
Write-Progress -ParentId 1 -Activity "Evaluating C Drive details VCenter level"
$CVDsik = Get-FromVMinfo -VM $srv.server -Vcenter $srv.vcenter -ErrorAction Stop
$e.Vcheck = "Successful"

}
Catch {$e.Vcheck = "Failed"
}

$e | Export-Csv $home\desktop\Cchekfail.csv -Append

####################

Write-Progress -ParentId 1 -Activity "Making Report"


if ($Cdrive -and $CVDsik) {
$report = [pscustomobject][ordered]@{

    Server = $srv.Server
    IsCdriveCanBeIncreased = $Cdrive.PartitionIndex -eq $($Cdrive.PartitionCount-1)
    IsDataStoreHaveEnoughSpace= $CVDsik.DataStoreFreeSpacePER -ge '20'



}

$report | Add-Member -NotePropertyMembers $Cdrive -Force 
$report| Add-Member -NotePropertyMembers $CVDsik 
Write-Progress -ParentId 1 -Activity "Writing Report"
$report | Export-Csv $home\desktop\Cdrivecomana.csv -Append -Force
$p += 1

Clear-Variable report
}
}