


$env:COMPUTERNAME
$out = @()

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

$files = Get-ChildItem "c:\" -Force | where {!$_.PSIsContainer} 

foreach($file in $files)
{ 
$pro1 = @{
"Folder" = $file.FullName
"Size(GB)" = [math]::round($file.Length/ 1GB,2)
}
$out += New-Object psobject -Property $pro1 
}

$dirl1 = Get-ChildItem "c:\" -Force | where {$_.PSIsContainer} 

foreach($dir1 in $dirl1)
{
$files1 = Get-ChildItem "c:\" -Force | where {!$_.PSIsContainer}

foreach($file in $files1)
{ 
$pro1 = @{
"Folder" = $file.FullName
"Size(GB)" = [math]::round($file.Length/ 1GB,2)
}
$out += New-Object psobject -Property $pro1 
}
$folders = Get-ChildItem $dir1.FullName -Force | where {$_.PSIsContainer}

foreach($folder in $folders)
{
$Size =[math]::round(((Get-ChildItem $Folder.FullName -Recurse | Measure-Object -Property Length -Sum ).Sum / 1GB),2)
$pro = @{
"Folder" = $folder.FullName
"Size(GB)" = $Size
}
$out += New-Object psobject -Property $pro
}
}

