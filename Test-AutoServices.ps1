Function Test-AutoServices{
<#
.Synopsis
   Check if automatic services are started.
.DESCRIPTION
   The Test-AutoServices cmdlet check if services with the start type automatic are started.
   This is especially interesting as add-on to other scripts where after a reboot you want to make sure the system is ready for execution.
   Instead of the out-file you could change this to your own log module or write to the verbose or output stream.
   You can use the parameter ExcludeServices of Test-AutoServices to exclude the services that don't need to be checked.
.PARAMETER ExcludeServices 
Enter the services you want to exclude from the check. 
 .PARAMETER logfile 
Enter the path to log File.
.EXAMPLE
   Test-AutoServices

Description 
----------- 
This command will check all the services with the startup type automatic if there started. 

.EXAMPLE
   Test-AutoServices -ExcludeServices BBSvc,sppsvc

Description 
----------- 
This command will check all the services with the startup type automatic if there started.
Except the services BBSvc,sppsvc.
 
.NOTES    
Name: Test-AutoServices 
Author: Daan Weda 
DateUpdated: 2015-08-17 
Version: 1.0 
 
.LINK 
https://daanweda.wordpress.com/ 
Twitter: @Dweda 
 

#>

param
(
        [CmdletBinding()]
        [Parameter(Mandatory=$False,
        HelpMessage="Enter the Services you want to exclude")]
        [AllowEmptyString()]
        [String[]]$ExcludeServices,
        [Parameter(Mandatory=$True)]
        $logfile
       
      )

Begin
    {
    $TimeStart = get-date
    $TimeEnd = $TimeStart.AddMinutes(5)
    
    }

Process
{
Do
{
        [array]$AutoServicesNotStarted = Get-CimInstance Win32_Service -Filter "startmode = 'auto' AND state != 'running'" |
                                         where-object -Property Name -NotIn -Value $ExcludeServices
                                         Start-Sleep -Seconds 5
                                         $TimeStart = Get-Date
                                         "$TimeStart run again services not started  $($AutoServicesNotStarted.name)"| Out-file $logfile -Append

}until( $TimeStart.Minute -gt $TimeEnd.Minute -or $AutoServicesNotStarted.count -lt 1 )
}

End{

if( $AutoServicesNotStarted.count -gt 0) {$AutoServicesNotStarted|Format-Table -AutoSize @('Name','DisplayName','State','StartMode','StartName')| Out-file $logfile -Append}
else{'All auto services started'|out-file $logfile -Append}
Start-sleep 30
}
}




