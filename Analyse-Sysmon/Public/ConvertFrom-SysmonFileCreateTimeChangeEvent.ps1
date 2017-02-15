﻿function ConvertFrom-SysmonFileCreateTimeChangeEvent {
<#
.Synopsis
ConvertFrom a sysmon File Create Time Change event, returning an object with data

.DESCRIPTION
This commandlet takes a sysmon event and returns an object with the data from the event. Useful for further analysis. 


.EXAMPLE
$SysmonEvent = Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";Id=2;} | select -first 1
ConvertFrom-SysmonFileCreateTimeChangeEvent $SysmonEvent

.NOTES
 Author: Dave Bremer
 Hat-Tip: https://infracloud.wordpress.com/2016/05/12/read-sysmon-logs-from-powershell/
#>

    [cmdletBinding(DefaultParametersetName="user")]
    Param ([Parameter (
            Mandatory=$True,
            ValueFromPipelineByPropertyName = $TRUE,
            ValueFromPipeLine = $TRUE,
            Position = 0
                )]
            [ValidateNotNullOrEmpty()]
            [System.Diagnostics.Eventing.Reader.EventLogRecord] $Events)

 BEGIN {
    
   }
 
 PROCESS {
     Foreach ($event in $events) { 
        $eventXML = [xml]$Event.ToXml()
        Write-Verbose ("Event type {0}" -f $Event.Id)
        if ($Event.Id -ne 2) {
            Throw ("Event is type {0} - expecting type 2 Process Create event" -f $Event.Id)
        }
        # Create Object
    

        New-Object -Type PSObject -Property @{
            UTCTime = $eventXML.Event.EventData.Data[0].'#text'
            ProcessId = $eventXML.Event.EventData.Data[2].'#text'
            Image = $eventXML.Event.EventData.Data[3].'#text'
            TargetFilename = $eventXML.Event.EventData.Data[4].'#text'
            CreationUtcTime = $eventXML.Event.EventData.Data[5].'#text'
            PreviousCreationUtcTime = $eventXML.Event.EventData.Data[6].'#text'
        
        }
    }
}

END {}

}
Set-Alias -Name ConvertFrom-SysmonType2 -Value ConvertFrom-SysmonFileCreateTimeChangeEvent -Description “ConvertFrom Sysmon Event type 2 File Create Time Change”
#$SysmonEvent = Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";Id=2;} | select -first 1
#ConvertFrom-SysmonFileCreateTimeChangeEvent $SysmonEvent -Verbose