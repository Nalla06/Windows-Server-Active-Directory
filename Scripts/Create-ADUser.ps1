
Import-Module ActiveDirectory

$FirstName = "Markus"
$LastName = "Schneider"
$Username = "markus.schneider"
$UserOU = "OU=Users,OU=Company,DC=ad,DC=techoffice,DC=test"

$ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$Username'"

if ($ExistingUser) {
    Write-Host "User already exists: $Username" -ForegroundColor Yellow
}
else {
    $Password = Read-Host "Enter a temporary lab password" -AsSecureString

    New-ADUser `
        -Name "$FirstName $LastName" `
        -GivenName $FirstName `
        -Surname $LastName `
        -SamAccountName $Username `
        -UserPrincipalName "$Username@ad.techoffice.test" `
        -Path $UserOU `
        -Department "IT" `
        -Description "Fictional employee created using PowerShell" `
        -AccountPassword $Password `
        -Enabled $true `
        -ChangePasswordAtLogon $true

    Write-Host "User created: $Username" -ForegroundColor Green
}
