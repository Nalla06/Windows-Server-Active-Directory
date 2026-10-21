Part 8.4 — Public and Controlled-Write Folders

1. Project Overview

This scenario demonstrates how to configure a shared announcements folder where employees can read information but only authorised publishers can create or modify announcement files.

At TechOffice GmbH, company announcements must be available to employees while publishing rights remain restricted to designated users.

The objective is to separate read access from write access using Active Directory security groups and NTFS permissions.

2. Lab Environment

Component

Configuration

Server

Windows Server 2025

Server hostname

SRV-DC01

Active Directory domain

ad.techoffice.test

SMB share

\\SRV-DC01\CompanyData

Public folder

C:\CompanyData\Public

Announcements folder

C:\CompanyData\Public\Announcements

Publisher security group

GG-Announcement-Publishers

Intended publisher

Peter Weber

Read-only test user

Nina Braun

3. Business Scenario

Employees need to read company announcements, such as maintenance notices and internal updates. However, ordinary employees must not be able to publish or change announcement files.

Access requirements

Employees such as Nina can open and read the Announcements folder.

Nina cannot create or modify announcement files.

Authorised publishers can create and update announcement files.

Administrators and SYSTEM retain Full Control.

4. Folder Structure

The folder structure is:

C:\CompanyData
└── Public
    └── Announcements

The Announcements folder is a subfolder of the existing Public directory.

5. Active Directory Publisher Group

The dedicated security group is:

GG-Announcement-Publishers

Peter Weber is the intended member of this group.

Using a dedicated group means that publishing permissions can be managed by changing group membership rather than repeatedly modifying the folder’s NTFS permissions.

Before completing the publisher test: verify that Peter is a member of GG-Announcement-Publishers. If you have just added him, sign out and sign back in to refresh his logon security token.

6. NTFS Permission Configuration

The Public folder originally contained broad Users permissions that included file-creation and append rights. These entries allowed ordinary users to create files or folders.

The Announcements folder was configured with more restrictive permissions:

Open C:\CompanyData\Public\Announcements Properties.

Select Security → Advanced.

Disable inheritance and convert inherited permissions into explicit permissions.

Remove the broad BUILTIN\Users entries granting CreateFiles and AppendData.

Retain BUILTIN\Users with Read & Execute only.

Grant GG-Announcement-Publishers Modify, applying to this folder, subfolders and files.

Retain Full Control for Administrators and SYSTEM.

Intended permissions

Identity

Permission

Purpose

BUILTIN\Administrators

Full Control

Administrative management

NT AUTHORITY\SYSTEM

Full Control

Windows system operations

BUILTIN\Users

Read & Execute

Employees can view announcements

AD\GG-Announcement-Publishers

Modify

Authorised publishers can create and update announcements

CREATOR OWNER

Retained if present

Applies creator-related permissions to child items, where applicable

Verify the final ACL on your server before treating this table as the exact final state.

7. Verify NTFS Permissions

Run this command on SRV-DC01 in PowerShell:

Get-Acl "C:\CompanyData\Public\Announcements" |
    Select-Object -ExpandProperty Access |
    Format-Table IdentityReference,
                 FileSystemRights,
                 AccessControlType,
                 IsInherited -AutoSize

Check that:

BUILTIN\Users has Read & Execute access but not the broad file-creation or append permissions.

AD\GG-Announcement-Publishers has Modify access.

Administrators and SYSTEM retain Full Control.

8. Access Testing

Test A — Nina’s read-only access

Nina was able to open the Announcements folder but could not create a text document.

Test

Expected result

Result

Nina opens Announcements

Access allowed

Passed

Nina creates a text document

Access denied

Passed

This confirms that ordinary user access is restricted to reading rather than publishing.

Test B — Peter’s publisher access

Sign in as Peter and open:

\\SRV-DC01\CompanyData\Public\Announcements

Try creating a test file named Announcement-Test.txt.

Test

Expected result

Result

Peter opens Announcements

Access allowed

Pending verification

Peter creates Announcement-Test.txt

File creation allowed

Pending verification

Only change these results to Passed after confirming the test succeeds. If Peter cannot create a file, verify his group membership, refresh his logon session, and inspect the folder ACL.

9. Key Technical Concepts

Read-only versus Modify access

Read & Execute allows users to view folder contents and open files they can read. Modify additionally allows file and folder changes, including creation and deletion within the permitted scope.

Group-based publishing rights

A dedicated publisher group makes access easier to maintain. New publishers can be added to the group without redesigning the folder’s permission entries.

NTFS permissions and share permissions

The SMB share permission and NTFS permissions both affect access through the network share. Effective access depends on both sets of permissions; a broad share permission does not override a restrictive NTFS ACL.

Testing both access paths

A successful read test alone is not enough. Testing that an ordinary user cannot write and that an authorised publisher can write verifies both sides of the intended access model.

10. Evidence and Screenshots

Save actual screenshots in your existing Images directory. Suggested filenames:

20-announcement-publisher-group.png — publisher group and its members

21-announcements-ntfs-permissions.png — Advanced Security Settings for Announcements

22-announcement-peter-create-success.png — Peter successfully creating the test file

23-announcement-nina-read-only.png — Nina opening the folder and being denied file creation

Use the actual filenames of your screenshots when adding Markdown image links.

11. Outcome

The Announcements folder has been configured to allow read access for ordinary employees while reserving write access for the designated publisher group. Nina’s read-only test passed. Peter’s publishing result must be verified before this scenario is marked fully complete.

Skills demonstrated: NTFS ACL management, Active Directory security groups, read-only access, controlled publishing, SMB and NTFS permission interaction, and access validation.