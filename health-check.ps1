
# Run via copypasta'ing this command in powershell: iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Salad360/health-check/main/health-check.ps1'))

# May reqire first running this command: [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"


Write-Output "Login Test" >> .\results.txt
Write-Output "-----------" >> .\results.txt


# Test Administrator Credential
$cred = Get-Credential -Message "Enter credentials for the built-in domain admin account" #Read credentials
$username = $cred.username
$password = $cred.GetNetworkCredential().password

# Get current domain using logged-on user's credentials
$CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
$domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$UserName,$Password)

if ($domain.name -eq $null)
{
write-output "Primary Domain Admin: Authentication failed" >> .\results.txt

}
else
{
write-output "Primary Domain Admin: Pass" >> .\results.txt
}


# Test AMS domain admin credential

$cred = Get-Credential -Message "Enter credentials for the AMS domain admin account" #Read credentials
$username = $cred.username
$password = $cred.GetNetworkCredential().password

# Get current domain using logged-on user's credentials
$CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
$domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$UserName,$Password)

if ($domain.name -eq $null)
{
write-output "AMS Admin: Authentication failed" >> .\results.txt

}
else
{
write-output "AMS Admin:: Pass" >> .\results.txt
}

# Collect Hard Disk Stats

Write-Output "Hard Drives" >> results.txt
Write-Output "----------">> results.txt


# Functions for reporting diskspace usage for drives C: through G:
function Get-CUsage {
    $CDiskUsed = ((Get-PSDrive C).Used) / 1000000000 

    $CDiskFree = ((Get-PSDrive C).Free) / 1000000000
    Write-Output "C: $($CDiskUsed) GB used, $($CDiskFree) GB free"
}

Get-CUsage >> .\results.txt

Write-Output "Other drives:" >> .\results.txt

function Get-DUsage {
    $DDiskUsed = ((Get-PSDrive D).Used) / 1000000000 

    $DDiskFree = ((Get-PSDrive D).Free) / 1000000000

     if ($DDiskUsed -le 1) {
        Write-Output "No D: Present" >> .\results.txt
     }else { 
        Write-Output "D: $($DDiskUsed) GB used, $($DDiskFree) GB free" >> .\results.txt
     }
}


Get-DUsage

function Get-EUsage {
    $EDiskUsed = ((Get-PSDrive E).Used) / 1000000000 

    $EDiskFree = ((Get-PSDrive E).Free) / 1000000000

     if ($EDiskUsed -le 1) {
        Write-Output "No E: Present" >> .\results.txt
     }else { 
        Write-Output "E: $($EDiskUsed) GB used, $($EDiskFree) GB free" >> .\results.txt
     }
}

Get-EUsage

function Get-FUsage {
    $FDiskUsed = ((Get-PSDrive F).Used) / 1000000000 

    $FDiskFree = ((Get-PSDrive F).Free) / 1000000000

     if ($FDiskUsed -le 1) {
        Write-Output "No F: Present" >> .\results.txt
     }else { 
        Write-Output "F: $($FDiskUsed) GB used, $($FDiskFree) GB free" >> .\results.txt
     }
}


Get-FUsage

function Get-GUsage {
    $GDiskUsed = ((Get-PSDrive G).Used) / 1000000000 

    $GDiskFree = ((Get-PSDrive G).Free) / 1000000000

     if ($GDiskUsed -le 1) {
        Write-Output "No G: Present" >> .\results.txt
     }else { 
        Write-Output "G: $($GDiskUsed) GB used, $($GDiskFree) GB free" >> .\results.txt
     }
}

Get-GUsage


# TODO: Implement Disk health reporting if it's even possible w/o external tools

Read-Host "Now run the following cmdlet in an elevated PS window: Get-Disk | Get-StorageReliabilityCounter | Select-Object -Property "*""



Write-Output "Drives healthy?" >> .\results.txt

# CPU/MEM usage

Write-Output "Task Manager" >> results.txt
Write-Output "----------">> results.txt


#Write-Output "CPU Usage (%):" >> .\results.txt

#Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object Average | Format-Table -HideTableHeaders >> .\results.txt

# Function to get CPU load once every 5 seconds for 30 seconds and calculate the average
# -Filter "DeviceID" is needed because many ESXi VMs are presented with multiple CPU sockets rather than threads, without filter, a load value is produced for each "socket" which breaks
# the calculation for $Avg
function Get-CPULoadAvg {
    $C1 = ((Get-WmiObject Win32_Processor -Filter "DeviceID='CPU0'").LoadPercentage)
    Write-Output "Measuring CPU load averaged over 30 seconds"
    timeout.exe 5
    $C2 = ((Get-WmiObject Win32_Processor -Filter "DeviceID='CPU0'").LoadPercentage)
    Write-Output "Measuring CPU load averaged over 30 seconds"
    timeout.exe 5
    $C3 = ((Get-WmiObject Win32_Processor -Filter "DeviceID='CPU0'").LoadPercentage)
    Write-Output "Measuring CPU load averaged over 30 seconds"
    timeout.exe 5
    $C4 = ((Get-WmiObject Win32_Processor -Filter "DeviceID='CPU0'").LoadPercentage)
    Write-Output "Measuring CPU load averaged over 30 seconds"
    timeout.exe 5
    $C5 = ((Get-WmiObject Win32_Processor -Filter "DeviceID='CPU0'").LoadPercentage)
    Write-Output "Measuring CPU load averaged over 30 seconds"
    timeout.exe 5
    $C6 = ((Get-WmiObject Win32_Processor -Filter "DeviceID='CPU0'").LoadPercentage)


    $CAvg = ($C1 + $C2 + $C3 + $C4 + $C5 + $C6) / 6

    Write-Output "CPU Usage: $($CAvg) %" >> .\results.txt
}

Get-CPULoadAvg



# Note to self: the "((xxx).xxx)" Format outputs the object as an int rather than a string like doing -Select-Object would so you can do teh maths on them

$FreeMemKB = ((Get-CIMInstance Win32_OperatingSystem).FreePhysicalMemory)

# Super gud maths for converting KB to GB

$FreeMemGB = $FreeMemKB / 1000000
$TotalRAMKBytes = ((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize)

$TotalRAMGBytes = $TotalRAMKBytes / 1000000

Write-Output "Memory Usage: $($FreeMemGB) GB free of $($TotalRAMGBytes) GB" >> .\results.txt


# Get Disk I/O

$diskUsage = Get-Counter -Counter "\LogicalDisk(_Total)\% Disk Time" | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue

$diskUsageFormatted = "{0:N2}%" -f $diskUsage

"Disk Usage: $diskUsageFormatted" >> .\results.txt


# Get installed AV software

Write-Output "Anti-Virus Protection:" >> .\results.txt
Write-Output "----------------------" >> .\results.txt

$AV = ((Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct).displayName)

   if ($AV -eq 'Windows Defender') {
      Write-Output "Protected? No" >> .\results.txt
   } else {
      Write-Output "Protected? Yes" >> .\results.txt
      Write-Output "With What? $($AV)" >> .\results.txt
   
   }
 
   Write-Output "AV and definitions up-to-date?" >> .\results.txt


   # Backup Protection (For now to remain a manual-check proccess)

#   Write-Output "Backup Protection" >> .\results.txt
   Write-Output "------------------" >> .\results.txt
#   Write-Output "Backups active and monitored?" >> .\results.txt

$BackupService = ((Get-Service "DattoBackupAgentService").Status)

   if ($BackupService -eq 'Running') {
      Write-Output "Backup Active and monitored?: Yes" >> .\results.txt
   } else {
      Write-Output "Backup Active and monitored?: No" >> .\results.txt 
   }


#   # Windows Updates

# Allows semi-automated Windows updates via PsWindowsUpdate Module. Requires at least Powershell 5 which is only included in Server 2016 and up

$WinVer = Read-Host "Is this a Server2012 or older machine?(Y/N)" 

if ($WinVer -eq "y"){ 
	Write-Output "Windows Update:" >> .\results.txt
}else{

	Install-Module -Name PsWindowsUpdate
	$PendingUpdates = Get-Windowsupdate
	
}

if ($PendingUpdates -eq $null) {
	Write-output "Windows Update: Up-to-date" >> .\results.txt

}else{
	Write-Output "Windows Update: Updates Pending" >> .\results.txt
}

# Search for Critical events in event log

Write-output "Event Viewer:" >> .\results.txt
Write-output "-----------" >> .\results.txt  


# Get Application Critical Events
$appevents = Get-WinEvent -FilterHashtable @{LogName='Application'; Level=1} -MaxEvents 100

if ($appevents.Count -eq 0) {
	Write-Output "Application: No Critical Events" >> .\results.txt
} else {
    $appevents; Write-Output "Application:" >> .\results.txt
}

# Get System Critical Events
$sysevents = Get-WinEvent -FilterHashtable @{LogName='System'; Level=1} -MaxEvents 100

if ($sysevents.Count -eq 0) {
	Write-Output "System: No Critical Events" >> .\results.txt
} else {
    $sysevents; Write-Output "System:" >> .\results.txt
}

# Get Security Critical Events


$secevents = Get-WinEvent -FilterHashtable @{LogName='Security'; Level=1} -MaxEvents 100

if ($secevents.Count -eq 0) {
	Write-Output "Security: No Critical Events" >> .\results.txt
} else {
    $secevents; Write-Output "Security:" >> .\results.txt
}

Write-Output "Overall Diagnostics:" >> .\results.txt