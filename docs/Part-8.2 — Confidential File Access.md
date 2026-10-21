# Part 8.2 — Confidential File Access

## 1. Project Overview

This scenario demonstrates how to protect confidential departmental files on a Windows Server file server by using Active Directory security groups and NTFS permissions.

In the simulated company environment, TechOffice GmbH stores confidential Finance documents that must only be accessible to specifically authorised employees.

The objective is to apply the principle of **least privilege**: employees should receive only the access required for their responsibilities.

## 2. Lab Environment

| Component | Configuration |
|---|---|
| Server | Windows Server 2025 |
| Server hostname | `SRV-DC01` |
| Active Directory domain | `ad.techoffice.test` |
| File server share | `\\SRV-DC01\CompanyData` |
| Confidential folder | `C:\CompanyData\Finance\Confidential` |
| Authorised user | `AD\peter.weber` |
| Unauthorised test user | `AD\nina.braun` |
| Security group | `GG-Finance-Confidential` |

## 3. Business Scenario

The Finance department stores confidential documents that should not be available to every member of the department.

The existing Finance folder grants Modify permissions to `GG-Finance`. Applying those permissions to the confidential subfolder would give every Finance group member access.

To prevent this, a separate security group is used for confidential access.

### Access requirements

- Peter Weber must be able to open the confidential folder and create files.
- Nina Braun must not be able to open the confidential folder.
- Administrators and the SYSTEM account must retain Full Control.
- Other Finance group members must not gain access through inherited Finance permissions.

## 4. Active Directory Security Group

Created the following group in Active Directory Users and Computers:

| Setting | Value |
|---|---|
| Group name | `GG-Finance-Confidential` |
| Group scope | Global |
| Group type | Security |
| Member | Peter Weber |

Peter Weber is authorised through group membership rather than by granting permissions to a broad department group.

## 5. Folder and NTFS Permissions

The confidential folder is located at:

`C:\CompanyData\Finance\Confidential`

Initially, the folder inherited permissions from its parent Finance folder. This included access for `GG-Finance` and `BUILTIN\Users`.

To restrict access, inheritance was disabled and the inherited permissions were converted into explicit permissions. The broad Finance group and Users entries were then removed.

### Final intended permissions

| Identity | Permission | Purpose |
|---|---|---|
| `BUILTIN\Administrators` | Full Control | Administrative management |
| `NT AUTHORITY\SYSTEM` | Full Control | Windows system operations |
| `AD\GG-Finance-Confidential` | Modify | Authorised confidential-file access |
| `CREATOR OWNER` | Full Control | Permissions for the creator of child items, where applicable |

The permissions were configured as explicit entries on the confidential folder rather than inherited from the parent folder.

## 6. Permission Verification

The following PowerShell command was used to inspect the folder’s NTFS permissions:

```powershell
Get-Acl "C:\CompanyData\Finance\Confidential" |
    Select-Object -ExpandProperty Access |
    Format-Table IdentityReference,
                 FileSystemRights,
                 AccessControlType,
                 IsInherited -AutoSize
```

The `IsInherited` column helps verify whether an access-control entry is inherited from a parent folder or explicitly configured on the confidential folder.

## 7. Access Testing

Testing was performed using the domain accounts from the Windows client.

| Test | Expected result | Result |
|---|---|---|
| Peter opens the Confidential folder | Access allowed | Passed |
| Peter creates `Salary-Test.txt` | File creation allowed | Passed |
| Nina opens the Confidential folder | Access denied | Passed |
| Nina accesses the regular Finance folder | Access allowed according to its existing permissions | Passed |

These tests demonstrate that access to the confidential folder is narrower than access to the general Finance folder.

## 8. Key Technical Concepts

### NTFS permission inheritance

Subfolders normally inherit access permissions from their parent folders. Disabling inheritance allows permissions to be controlled separately for a sensitive folder.

### Active Directory security groups

Assigning permissions to `GG-Finance-Confidential` makes access easier to manage. Administrators can add or remove authorised employees through group membership instead of repeatedly changing the folder ACL.

### Least privilege

The confidential folder grants Modify access only to the dedicated authorisation group, while retaining the necessary administrative and system permissions.

### Validation with separate accounts

Testing both an authorised and an unauthorised user helps verify that the intended access restrictions work in practice.

## 9. Evidence and Screenshots

Add your actual screenshots to the existing `Images` directory. Suggested filenames are:

- `14-confidential-folder-permissions.png` — the folder’s Security or Advanced Security Settings window
- `15-confidential-access-denied-nina.png` — Nina’s Access Denied result
- `16-confidential-access-success-peter.png` — Peter opening the folder or creating the test file

If your screenshot filenames differ, update the links below to match the actual filenames.

Example:

```markdown
![Confidential folder NTFS permissions](Images/14-confidential-folder-permissions.png)

![Nina denied access to confidential files](Images/15-confidential-access-denied-nina.png)

![Peter accessing confidential files](Images/16-confidential-access-success-peter.png)
```

## 10. Outcome

This scenario demonstrates practical Windows Server file-server administration using Active Directory security groups, NTFS permissions, inheritance management, and user-based access testing.

The confidential Finance folder was successfully restricted so that Peter Weber could access it while Nina Braun was denied access.

**Skills demonstrated:** NTFS ACL management, permission inheritance, Active Directory group-based access control, least privilege, and access troubleshooting.
