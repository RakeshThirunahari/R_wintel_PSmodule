Function Get-LocalSecpol 
{
    Param
    (
        # Paramhelp description
        [string]
        $ListPath       
    )

    $Complist = Get-Content -Path $ListPath

    foreach ($Comp in $Complist)
    {

    Invoke-Command -ComputerName $Comp -ScriptBlock {secedit /export /cfg c:\temp\secpol.txt ; Get-Content -Path 'c:\temp\secpol.txt'; Remove-Item c:\temp\secpol.txt} | Out-File $HOME\desktop\secpoldump\$comp.csv

}

}