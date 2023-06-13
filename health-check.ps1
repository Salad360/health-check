

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



