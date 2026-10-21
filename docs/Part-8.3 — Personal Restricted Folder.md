# Part 8.3 — Personal Restricted Folder

## 1. Project Overview

This scenario demonstrates how to configure a personal restricted folder on a Windows Server file server using NTFS permissions.

At TechOffice GmbH, an employee may need a folder for individual work documents that should not be accessible to other departmental employees.

The objective is to give one named domain user access to a specific folder while retaining the required administrative and system permissions.

## 2. Lab Environment

| Component | Configuration |
|---|---|
| Server | Windows Server 2025 |
| Server hostname | `SRV-DC01` |
| Active Directory domain | `ad.techoffice.test` |
| File server share | `\\SRV-DC01\CompanyData` |
| Parent folder | `C:\CompanyData\Finance` |
| Restricted folder | `C:\CompanyData\Finance\Nina-Private` |
| Authorised user | `AD\nina.braun` |
| Unauthorised test user | `AD\peter.weber` |

## 3. Business Scenario

Nina Braun needs a private folder for her individual work documents. Other Finance department employees should not automatically receive access through the department’s normal folder permissions.

### Access requirements

- Nina must be able to open her private folder.
- Nina must be able to create and modify files within it.
- Peter must not be able to open the folder.
- Administrators and the SYSTEM account must retain Full Control.

## 4. Folder Configuration

The folder was created at:

`C:\CompanyData\Finance\Nina-Private`

It is located beneath the Finance directory, but its access permissions are configured independently from the parent folder.

## 5. NTFS Permission Configuration

Initially, the folder inherited permissions from the Finance directory. These included Modify access for `GG-Finance` and Read and Execute access for `BUILTIN\Users`.

Those inherited entries would allow other users broader access than required.

To restrict the folder:

1. Open the folder’s **Properties**.
2. Select **Security → Advanced**.
3. Select **Disable inheritance**.
4. Choose to convert inherited permissions into explicit permissions.
5. Remove the `AD\GG-Finance` and `BUILTIN\Users` entries.
6. Add `AD\nina.braun` and grant **Modify**.
7. Set the permission to apply to **This folder, subfolders and files**.
8. Retain Full Control for Administrators and SYSTEM.

### Final intended permissions

| Identity | Permission | Purpose |
|---|---|---|
| `BUILTIN\Administrators` | Full Control | Administrative management |
| `NT AUTHORITY\SYSTEM` | Full Control | Windows system operations |
| `AD\nina.braun` | Modify | Nina can create and change files |
| `CREATOR OWNER` | Full Control | Permissions for the creator of child items, where applicable |

The general Finance group and broad Users entries are not retained on this restricted folder.

## 6. Verify the NTFS Permissions

The following PowerShell command displays the folder’s access-control entries:

```powershell
Get-Acl "C:\CompanyData\Finance\Nina-Private" |
    Select-Object -ExpandProperty Access |
    Format-Table IdentityReference,
                 FileSystemRights,
                 AccessControlType,
                 IsInherited -AutoSize
```

The `IsInherited` column helps confirm whether permissions are inherited or explicitly configured on this folder.

## 7. Access Testing

Testing was performed using separate domain user accounts.

| Test | Expected result | Result |
|---|---|---|
| Nina opens `Nina-Private` | Access allowed | Passed |
| Nina creates a test file | File creation allowed | Passed |
| Peter opens `Nina-Private` | Access denied | Passed |

These results demonstrate that Nina has the required access while Peter is prevented from accessing her personal folder.

## 8. Key Technical Concepts

### User-specific permissions

NTFS permissions can be assigned directly to a domain user when access is intended for one individual. In larger environments, security groups are often preferred for easier ongoing administration.

### Permission inheritance

A folder can have different permissions from its parent. Disabling inheritance and removing broad inherited entries prevents the parent folder’s access rules from automatically granting access to other users.

### Modify versus Full Control

**Modify** allows a user to read, create, change and delete files within the permitted scope. **Full Control** includes additional permission-management capabilities, so it is not normally necessary for an ordinary employee.

### Negative access testing

Testing with Peter confirms that the folder is not merely accessible to Nina, but is also restricted against the other test user.

## 9. Evidence and Screenshots

Save your actual screenshots in the existing `Images` directory. Suggested filenames:

- `17-nina-private-permissions.png` — Advanced Security Settings for the folder
- `18-nina-private-access-success.png` — Nina opening the folder or creating a file
- `19-nina-private-access-denied-peter.png` — Peter receiving Access Denied

Use your actual screenshot filenames if they differ.

Example Markdown:

```markdown
![Nina private folder permissions](Images/17-nina-private-permissions.png)

![Nina accessing her private folder](Images/18-nina-private-access-success.png)

![Peter denied access to Nina's private folder](Images/19-nina-private-access-denied-peter.png)
```

## 10. Outcome

The personal restricted folder was successfully configured and tested. Nina Braun can access and modify files in her folder, while Peter Weber is denied access.

**Skills demonstrated:** NTFS permission configuration, inheritance management, user-specific access control, permission scope, and positive and negative access testing.
