function test-flow { 
hostname
secedit /export /cfg c:\temp\secpol.txt 
Get-Content -Path 'c:\temp\secpol.txt' 
Remove-Item c:\temp\secpol.txt
}