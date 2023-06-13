#
#############################################################
##Template for results.txt
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



Write-Output "Login Test" >> results.txt
Write-Output "----------">> results.txt


# Test AD Auth for Administrator Account

Function Test-ADAuthentication {
    param(
        $username,
        $password)

        $username = Administrator
        
        $password = Read-Host -Prompt "Enter Default Domain Administrator Password"
        if ((New-Object DirectoryServices.DirectoryEntry "",$username,$password).psbase.name -ne $null) {
            Write-Output "Administrator: Pass" > results.txt
        
        } else {
            Write-Output Administrator: Fail >> results.txt
        }
}

Test-ADAuthentication -username $UserName -password $password


# Do the same for AMS admin account

Function Test-ADAuthentication {
    param(
        $username,
        $password)

        $username = AMS
        
        $password = Read-Host -Prompt "Enter AMS admin Password"


    if ((New-Object DirectoryServices.DirectoryEntry "",$username,$password).psbase.name -ne $null) {
        Write-Output "AMS Admin: Pass" > results.txt
    
    } else {
        Write-Output "AMS Admin: Fail" >> results.txt
    }
}

Test-ADAuthentication -username $UserName -password $password



# Collect Hard Disk Stats

Write-Output "Hard Drives" >> results.txt
Write-Output "----------">> results.txt



Get-PSDrive C >> .\results.txt




