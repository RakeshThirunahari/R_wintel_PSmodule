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
function TLogoff-Discusers
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
    Write-Verbose "Commandlet version 1.2"
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