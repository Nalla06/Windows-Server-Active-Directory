## 08- File Server Administration and NTFS Permissions

#### Project Overview

This project demonstrates practical Windows Server file-server administration in a simulated company environment, TechOffice GmbH. It focuses on configuring shared folders, managing access through Active Directory security groups, applying NTFS permissions, and validating access from domain-joined Windows clients.

The lab demonstrates how file access can be organised according to departmental responsibilities, confidentiality requirements, individual user needs, and controlled publishing workflows.

#### Objectives

- Configure a central SMB file share and departmental folder structure.
- Apply NTFS permissions using Active Directory security groups.
- Restrict access to confidential records.
- Configure a personal restricted folder for an individual employee.
- Provide read-only access to shared announcements while limiting publishing rights.
- Verify permissions through PowerShell and client-side access tests.
- Document troubleshooting steps and access-control decisions.

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

#### Practical Scenarios

######  Part 8.1 — Department File Sharing

Configure Finance and HR folders with group-based permissions and verify departmental write access.

###### Part 8.2 — Confidential File Access

Restrict the Finance confidential folder to members of GG-Finance-Confidential and test authorised and unauthorised access.

###### Part 8.3 — Personal Restricted Folder

Configure an employee-specific folder for Nina and verify that another employee cannot access it.

###### Part 8.4 — Public and Controlled-Write Folders

Configure an announcements folder for employee read access and controlled publishing through GG-Announcement-Publishers.

###### Part 8.5 — Troubleshooting and Final Validation

Review the permission configuration, document troubleshooting exercises, and consolidate the final test results.

#### Key Technical Skills

- SMB file sharing
- NTFS access control and permission inheritance
- Active Directory security groups
- Role-based access management
- Least-privilege access design
- PowerShell ACL inspection
- Access validation and troubleshooting
- Technical documentation and evidence collection

Results

The lab includes practical access tests for departmental, confidential, personal, and read-only folder scenarios. Final verification of the publishing workflow and consolidated documentation will be recorded as those checks are completed.
