# HelloID-Task-SA-Target-ActiveDirectory-AccountPasswordReset

## Prerequisites

- [ ] The HelloID SA on-premises agent installed

- [ ] The ActiveDirectory module is installed on the server where the HelloID SA on-premises agent is running.

## Description

This code snippet will administratively reset the password a user within Active Directory and executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hash table represent the properties required for the execution of the password reset task, while the values represent the values entered in the form.

> To view an example of form output, please refer to the JSON code pasted below.

```json
{
   "UserPrincipalName": "testuser@mydomain.local",
   "password" : "mySecretpassword191287436235^",
   "ChangePasswordAtNextLogon" : true
}
```

> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hashtable is appropriately adjusted to match your form fields.

2. Imports the ActiveDirectory module.

3. Verifies that the account of which the password must be reset exists based on the `userPrincipalName` using the `Get-ADUser` cmdlet.

4. If the account does exist, the password is reset using the `Set-ADAccountPassword` cmdlet, otherwise an error is generated.

5. After succesfully resetting the password, the `Set-ADUser` cmdlet is run to set the flag "user must change password at next logon" to the specified value.
