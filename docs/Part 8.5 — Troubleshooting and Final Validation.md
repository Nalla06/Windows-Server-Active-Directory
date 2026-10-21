# Part 8.5 — Troubleshooting and Final Validation

## 1. Project Overview

This scenario completes the file-server administration project for the simulated company TechOffice GmbH.

The focus is on validating NTFS permissions, checking Active Directory group membership, troubleshooting access-denied errors, and confirming that the file server behaves as intended.

In a real IT support or system administration role, configuring permissions is only part of the task. An administrator must also verify the configuration and investigate unexpected access results.

## 2. Lab Environment

| Component | Configuration |
|---|---|
| Server operating system | Windows Server 2025 |
| Server hostname | `SRV-DC01` |
| Active Directory domain | `ad.techoffice.test` |
| File server share | `\\SRV-DC01\CompanyData` |
| Local share path | `C:\CompanyData` |
| Virtualisation platform | VMware Workstation Pro 17.6.2 |

## 3. Final Folder Structure

The file server contains the following departmental and restricted folders:

```text
C:\CompanyData
├── Finance
│   ├── Confidential
│   └── Nina-Private
├── HR
└── Public
    └── Announcements
```

Each folder has its own access requirements. The parent folder’s permissions are not assumed to be appropriate for every subfolder.

## 4. Final Access Requirements

| Folder | Intended access |
|---|---|
| `Finance` | Finance group members have Modify access |
| `HR` | HR group members have Modify access |
| `Finance\Confidential` | Members of `GG-Finance-Confidential` have Modify access |
| `Finance\Nina-Private` | Nina Braun has Modify access |
| `Public\Announcements` | Ordinary users have read access; authorised publishers have Modify access |

Administrators and SYSTEM retain the required administrative and system permissions.

**Important:** The table describes the intended access model. Confirm the final ACLs on the server and verify Peter’s publisher test before reporting every scenario as fully passed.

## 5. PowerShell Permission Audit

The following command checks the access-control entries on all five important folders:

```powershell
$paths = @(
    "C:\CompanyData\Finance",
    "C:\CompanyData\HR",
    "C:\CompanyData\Finance\Confidential",
    "C:\CompanyData\Finance\Nina-Private",
    "C:\CompanyData\Public\Announcements"
)

foreach ($path in $paths) {
    Write-Host "`n===== $path =====" -ForegroundColor Cyan

    if (Test-Path $path) {
        (Get-Acl $path).Access |
            Format-Table IdentityReference,
                         FileSystemRights,
                         AccessControlType,
                         IsInherited -AutoSize
    }
    else {
        Write-Host "PATH NOT FOUND" -ForegroundColor Red
    }
}
```

### What this command verifies

- `Test-Path` checks whether each folder exists.
- `Get-Acl` retrieves the folder’s access-control list.
- `IdentityReference` identifies the user, group or built-in account.
- `FileSystemRights` shows the assigned permission.
- `AccessControlType` identifies Allow or Deny entries.
- `IsInherited` shows whether the entry comes from a parent folder.

Review the output against the intended access model rather than assuming that the presence of a permission entry alone proves that access works.

## 6. Troubleshooting Access Denied

When a user cannot access a folder, use a structured troubleshooting process.

### Step 1 — Confirm the path

Verify that the folder exists and that the user is accessing the intended location.

For example:

```powershell
Test-Path "C:\CompanyData\Finance\Confidential"
```

### Step 2 — Check Active Directory group membership

On the domain controller, inspect the relevant group:

```powershell
Get-ADGroupMember "GG-Finance-Confidential"
```

For the publisher group:

```powershell
Get-ADGroupMember "GG-Announcement-Publishers"
```

Confirm that the intended user is a member of the correct group.

### Step 3 — Inspect NTFS permissions

Run `Get-Acl` against the affected folder and check for missing permissions, unexpected inherited entries, or incorrect permission scope.

### Step 4 — Check share permissions

The network share is `\\SRV-DC01\CompanyData`. Share permissions and NTFS permissions both influence network access.

If NTFS permissions appear correct but access through the network share still fails, inspect the share configuration:

```powershell
Get-SmbShareAccess -Name "CompanyData"
```

### Step 5 — Refresh the user’s logon session

When a user has just been added to an Active Directory group, the existing logon session may not contain the updated group membership. Sign out and sign back in, then test again.

### Step 6 — Retest and record the result

Repeat the operation using the affected user account. Record the expected result, actual result, and any corrective action taken.

## 7. Lessons Learned

This lab demonstrates several important administration principles:

1. **Least privilege:** Users receive only the access needed for their tasks.
2. **Group-based administration:** Security groups simplify the management of shared access.
3. **Inheritance control:** Sensitive subfolders can have a separate permission model.
4. **Layered access control:** SMB share and NTFS permissions must be considered together.
5. **Verification:** PowerShell inspection and tests with different user accounts help validate the configuration.
6. **Troubleshooting:** Access problems can be investigated systematically instead of changing permissions at random.

## 10. Final Outcome

The file-server administration project covers departmental file sharing, confidential Finance access, a user-specific private folder, and controlled publishing for company announcements.

The lab combines GUI-based configuration, Active Directory security groups, NTFS permissions, PowerShell verification, and positive and negative access tests.

**Skills demonstrated:** Windows Server file-server administration, NTFS ACL troubleshooting, SMB share validation, Active Directory group management, PowerShell administration, and technical documentation.
