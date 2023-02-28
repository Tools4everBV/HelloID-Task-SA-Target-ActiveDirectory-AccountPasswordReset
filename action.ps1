# HelloID-Task-SA-Target-ActiveDirectory-AccountPasswordReset
###################################################################
# Form mapping

$formObject = @{
    UserPrincipalName     = $form.UserPrincipalName
    Password              = $form.password | ConvertTo-SecureString -AsPlainText -Force
    ChangePasswordAtLogon = [System.Convert]::ToBoolean($form.ChangePasswordAtNextLogon)
}

try {
    Write-Information "Executing ActiveDirectory action: [SetPassword], Reset Password for: [$($formObject.UserPrincipalName)]"
    Import-Module ActiveDirectory -ErrorAction Stop
    $adUser = Get-ADUser -Filter "userPrincipalName -eq '$($formObject.UserPrincipalName)'"
    if ($adUser) {

        $null = Set-ADAccountPassword -Identity $adUser -Reset -NewPassword $formObject.Password
        $null = Set-ADUser -Identity $adUser -ChangePasswordAtLogon $($formObject.ChangePasswordAtLogon)
        $auditLog = @{
            Action            = 'SetPassword'
            System            = 'ActiveDirectory'
            TargetIdentifier  = "$($adUser.SID.value)"
            TargetDisplayName = "$($formObject.UserPrincipalName)"
            Message           = "ActiveDirectory action: [SetPassword]. Password reset for: [$($formObject.UserPrincipalName)] executed successfully. Change at next logon:  $($formObject.ChangePasswordAtLogon)"
            IsError           = $false
        }

        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "ActiveDirectory action [SetPassword] () for: [$($formObject.UserPrincipalName)] executed successfully"
    }
    else {
        $auditLog = @{
            Action            = 'SetPassword'
            System            = 'ActiveDirectory'
            TargetIdentifier  = ""
            TargetDisplayName = "$($formObject.UserPrincipalName)"
            Message           = "ActiveDirectory action: [SetPassword]. Password reset  for: [$($formObject.UserPrincipalName)] cannot execute. The account cannot be found in the AD."
            IsError           = $true
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Error "ActiveDirectory action: [SetPassword]. Password reset  for: [$($formObject.UserPrincipalName)] cannot execute. The account cannot be found in the AD."
    }
}
catch {
    $ex = $_
    $auditLog = @{
        Action            = 'SetPassword'
        System            = 'ActiveDirectory'
        TargetIdentifier  = '' # optional (free format text)
        TargetDisplayName = "$($formObject.UserPrincipalName)"
        Message           = "ActiveDirectory action: [SetPassword]. Password reset failed for: [$($formObject.UserPrincipalName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    Write-Information -Tags "Audit" -MessageData $auditLog
    Write-Error "ActiveDirectory action: [SetPassword]]. Password reset  failed for : [$($formObject.UserPrincipalName)], error: $($ex.Exception.Message)"
}
###################################################################
