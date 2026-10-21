# Part 8.1 — Department File Sharing

## 1. Objective

The objective of this scenario was to configure a central file-sharing structure for TechOffice GmbH and control departmental write access using Active Directory security groups and NTFS permissions.

Finance and HR employees require access to their department's shared files, while users from other departments must not be able to create or modify files in folders they do not manage.

## 2. Lab Environment

| Component | Configuration |
|---|---|
| Server | `SRV-DC01` |
| Operating system | Windows Server 2025 |
| Domain | `ad.techoffice.test` |
| Server IP | `192.168.10.10` |
| Main data directory | `C:\CompanyData` |
| SMB share | `\\SRV-DC01\CompanyData` |
| Finance folder | `C:\CompanyData\Finance` |
| HR folder | `C:\CompanyData\HR` |
| Finance security group | `GG-Finance` |
| HR security group | `GG-HR` |

## 3. Folder and Share Configuration

The following folder structure was created on the server:

```text
C:\CompanyData
├── Finance
├── HR
└── Public
```

The `CompanyData` folder was shared over SMB so domain users could access the files from their Windows client computers.

The share permission for `Everyone` was configured with **Change** and **Read**. NTFS permissions were then used to control access to the individual folders.

Share permissions control access over the network, while NTFS permissions control access to files and folders on the server. Both sets of permissions apply when a user accesses a folder through an SMB share.

## 4. NTFS Permission Design

### Finance

The `GG-Finance` security group was granted **Modify** permission on the Finance folder.

The `BUILTIN\Users` group retained **Read & Execute** permission. This allows ordinary users to read and browse the folder but does not grant them departmental write access.

### HR

The `GG-HR` security group was granted **Modify** permission on the HR folder.

The `BUILTIN\Users` group retained **Read & Execute** permission.

### Administrative Access

The following permissions were retained:

- `BUILTIN\Administrators` — Full Control
- `NT AUTHORITY\SYSTEM` — Full Control

`CREATOR OWNER` was also retained in the folder ACLs.

## 5. Permission Verification

The NTFS permissions were inspected using PowerShell:

```powershell
$paths = @(
    "C:\CompanyData\Finance",
    "C:\CompanyData\HR"
)

foreach ($path in $paths) {
    Write-Host "`n--- $path ---"
    (Get-Acl $path).Access |
        Format-Table IdentityReference,
                     FileSystemRights,
                     AccessControlType,
                     IsInherited -AutoSize
}
```

The verification confirmed the intended departmental permissions:

- `GG-Finance` — Modify on Finance
- `GG-HR` — Modify on HR
- `BUILTIN\Users` — Read & Execute on both folders
- Administrators and SYSTEM — Full Control

## 6. Client-Side Testing

Access was tested from a domain-joined Windows 11 client.

| Test | Expected result | Observed result |
|---|---|---|
| Peter Weber creates a file in Finance | Allowed | Passed |
| Peter Weber creates a file in HR | Denied | Passed |

Peter Weber is a member of `GG-Finance`. He could create a test file in Finance but could not create a file in HR.

These tests demonstrated that departmental write access was controlled by security-group membership and NTFS permissions.

## 7. Technical Concepts Demonstrated

### NTFS Permissions

NTFS permissions define which users and groups can read, write, modify, or manage files and folders.

### Active Directory Security Groups

Security groups simplify permission management. Instead of assigning permissions separately to every employee, access is granted to a group whose membership represents a role or department.

### Permission Inheritance

Permissions may be inherited from parent folders. In this lab, the Finance and HR folders were configured with explicit permission entries to establish their departmental access rules.

### Least-Privilege Access

Users should receive only the permissions required for their work. Departmental Modify permissions were assigned to the relevant security groups, while broad user access remained read-only.

## 8. Outcome

The department file-sharing foundation was configured and tested successfully.

The lab demonstrated how an administrator can create an SMB share, organise departmental data, assign NTFS permissions through Active Directory security groups, inspect access-control entries using PowerShell, and validate the results from a client computer.

**Scope note:** The Finance and HR folders in this scenario permit broad read access through `BUILTIN\Users`. Confidentiality restrictions were implemented separately in Part 8.2.

## 9. Evidence

Add your screenshots below after confirming the image filenames in the repository.

Suggested evidence:

- Finance NTFS permissions
- HR NTFS permissions
- Successful Finance file creation
- Denied HR file creation

Example Markdown image reference:

```markdown
![Finance NTFS permissions](Images/10-finance-ntfs-permissions.png)
```
