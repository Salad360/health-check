#############################################################
#Template for results.txt
##############################################################
#Login test
#
#--------------
#
#Primary Domain Admin:
#AMS Admin:
#
#Hard drives:
#----------------
#C:
#Other drives:
#Drives healthy?
#
#Task Manager:
#--------------------
#Processor Usage:
#Memory Usage:
#HDD/SSD Activity:
#
#Anti-Virus Protection:
#----------------------------
#Protected?
#What with?
#AV and Definitions up to date?
#
#Backup Protection:
#--------------------------
#Backup active and monitored?
#
#Windows Update:
#-------------------------
#Device up to date?
#
#Event Viewer:
#------------------
#Application:
#System:
#Security:
#
#Overall Diagnostics:

#################################################################################################################
# Skipping login testing for now                                          
#################################################################################################################

#Write-Output "Login Test" >> results.txt
#Write-Output "----------">> results.txt
#
#
## Test AD Auth for Administrator Account
#
#Function Test-ADAuthentication {
#    param(
#        $username,
#        $password)
#
#        $username = Administrator
#        
#        $password = Read-Host -Prompt "Enter Default Domain Administrator Password"
#        if ((New-Object DirectoryServices.DirectoryEntry "",$username,$password).psbase.name -ne $null) {
#            Write-Output "Administrator: Pass" > results.txt
#        
#        } else {
#            Write-Output Administrator: Fail >> results.txt
#        }
#}
#
#Test-ADAuthentication -username $UserName -password $password
#
#
## Do the same for AMS admin account
#
#Function Test-ADAuthentication {
#    param(
#        $username,
#        $password)
#
#        $username = AMS
#        
#        $password = Read-Host -Prompt "Enter AMS admin Password"
#
#
#    if ((New-Object DirectoryServices.DirectoryEntry "",$username,$password).psbase.name -ne $null) {
#        Write-Output "AMS Admin: Pass" > results.txt
#    
#    } else {
#        Write-Output "AMS Admin: Fail" >> results.txt
#    }
#}
#
#Test-ADAuthentication -username $UserName -password $password







# Collect Hard Disk Stats

Write-Output "Hard Drives" >> results.txt
Write-Output "----------">> results.txt


# Might Clean this up later i.e. do something like $GB = ((Get-PSDrive C).Used) / 1000000000 etc. 

Get-PSDrive C >> .\results.txt

Write-Output "Other drives:" >> .\results.txt

Get-PSDrive D >> .\results.txt

Get-PSDrive E >> .\results.txt

Get-PSDrive F >> .\results.txt

Get-PSDrive G >> .\results.txt

# TODO: Implement Disk health reporting if it's even possible w/o external tools

# CPU/MEM usage

Write-Output "Task Manager" >> results.txt
Write-Output "----------">> results.txt


Write-Output "CPU Usage (%):" >> .\results.txt

Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object Average | Format-Table -HideTableHeaders >> .\results.txt

Write-Output "Memory Usage:" >> .\results.txt

# Note to self: the "((xxx).xxx)" Format outputs the object as an int rather than a string like doing -Select-Object would so you can do teh maths on them

$FreeMemKB = ((Get-CIMInstance Win32_OperatingSystem).FreePhysicalMemory)

# Super gud maths for converting KB to GB

$FreeMemGB = $FreeMemKB / 1000000
$TotalRAMKBytes = ((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize)

$TotalRAMGBytes = $TotalRAMKBytes / 1000000

Write-Output "$($FreeMemGB) GB free of $($TotalRAMGBytes) GB" >> .\results.txt

