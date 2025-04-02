#emrahtolu
$users = Import-Csv -Path C:\scripts\removeuser.csv

foreach ($user in $users) {
    $adUser = Get-ADUser -Identity $user.sAMAccountName -ErrorAction SilentlyContinue
    if ($adUser) {
        Remove-ADObject -Identity $adUser.DistinguishedName -Recursive -Confirm:$false
        Write-Host "Kullanıcı silindi: $($user.sAMAccountName)"
    } else {
        Write-Host "Kullanıcı bulunamadı: $($user.sAMAccountName)"
    }
}
