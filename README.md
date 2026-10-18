# Windows Server & Active Directory Administration Lab

![Windows Server Active Directory Lab Architecture](Project-Archtecture.png)

## Project Overview

This project demonstrates hands-on Windows Server administration in a simulated company environment called **TechOffice GmbH**.

The lab focuses on Windows Server, Active Directory Domain Services (AD DS), DNS, Organizational Unit (OU) management, user administration, and PowerShell automation.

The objective is to practise common IT administration tasks, verify configurations, troubleshoot problems, and document the procedures in a reusable technical runbook.


## Lab Environment

| Component | Configuration |
|---|---|
| Virtualisation platform | VMware Workstation Pro 17.6.2 |
| Host operating system | Windows 11 |
| Server operating system | Windows Server 2025 |
| Client operating system | Windows 11 |
| Domain controller | `SRV-DC01` |
| Domain controller IP address | `192.168.x.x` |
| Internal lab network | `192.168.x.0/24` |
| Virtual network | VMware host-only network (VMnet1) |
| Active Directory domain | `ad.techoffice.test` |
| Administration tools | Server Manager, ADUC, PowerShell |

## Work Completed

### 1. VMware Lab Setup and Network Configuration

- Created the virtual lab environment using VMware Workstation.
- Configured the host-only virtual network for the lab.
- Configured the Windows Server hostname and static IPv4 address.
- Checked the server's network and DNS settings.

### 2. Active Directory Domain Services

- Installed the Active Directory Domain Services role.
- Promoted the server to a domain controller.
- Created the Active Directory domain `ad.techoffice.test`.
- Reviewed the domain controller and DNS configuration.

### 3. Organizational Units and User Management

- Created the `Company` Organizational Unit.
- Created the `Users`, `Computers`, `Groups`, and `Servers` child OUs.
- Created an initial user account manually using Active Directory Users and Computers.
- Organised directory objects within the lab structure.

### 4. PowerShell User Provisioning

- Prepared a CSV file containing 50 fictional employee records.
- Developed a PowerShell script to automate individual user creation.
- Used a separate PowerShell script to process employee records in bulk.
- Implemented checks to skip accounts that already existed.
- Generated a provisioning results report.
- Began validating the resulting Active Directory accounts.
 
### 5. Active Directory Users, Security Groups & Windows 11 Domain Join
 
- Created and organised Active Directory user accounts.
- Created department-based Global Security groups.
- Audited user department attributes and group memberships.
- Intentionally left two users unassigned to their expected security groups for future access-control testing.
- Configured client DNS to locate the domain controller.
- Troubleshot DNS resolution and domain-controller discovery.
- Joined the Windows 11 client to the Active Directory domain.
- Tested domain-user sign-in and documented a password-change workaround.
- Recorded troubleshooting cases, verification results, and lessons learned.

### Part 6 — File Server and Access Permissions

- Created and shared the C:\Marketing folder on Windows Server 2025.
- Configured NTFS permissions for the GG-Marketing security group.
- Configured SMB share permissions for department-based access.
- Tested network file access from the Windows 11 domain client.
- Troubleshot read-only access and corrected share permissions to allow Marketing users to create files.
- Verified that a Marketing user could create a new file.
- Tested restricted write access using Julia Schulz's IT account.
- Documented permission inheritance, troubleshooting steps, and access-control test results.

### Part 7 – Group Policy Management and Security Filtering

- 7A – Baseline User Restrictions: Configure and test user restrictions using a baseline Group Policy Object (GPO).
- 7B – Targeted Group Policy Deployment: Apply additional user restrictions through Active Directory security groups and GPO security filtering.
- 7C – Non-Member Verification: Compare policy results for a group member and a non-member using gpupdate and gpresult.


## Documentation and Runbooks

The `docs` directory contains detailed procedures, technical explanations, screenshot evidence, verification commands, and troubleshooting notes.

| Document | Description |
|---|---|
| [Part 1 – VMware Lab Setup](docs/01-vmware-lab-setup.md) | Virtualisation, network design, and initial server configuration |
| [Part 2 – Active Directory Installation](docs/02-active-directory-installation.md) | AD DS role installation and domain controller promotion |
| [Part 3 – OU and User Management](docs/03-ou-and-user-management.md) | OU structure and manual user administration |
| [Part 4 – PowerShell User Provisioning](docs/04-powershell-user-provisioning.md) | Single-user automation and bulk provisioning from CSV |
| [Part 5 – Active Directory Users and Security Groups](docs/05-Active-Directory-Users-and-Security-Groups.md) | Department-based security groups, user membership audits, Windows 11 domain join, and domain sign-in troubleshooting |
| [Part 6 – File Server and Access Permissions](docs/06-File-Server-and-Access-Permissions.md) | NTFS and SMB share permissions, department-based file access, access-control testing, and troubleshooting |
| [Part 7 – Group Policy Management and Security Filtering](docs/Part-7-Group-Policy-Management.md) | Baseline user restrictions, targeted GPO deployment, security group filtering, and non-member verification |

## Repository Structure

```text
Windows-Server-Active-Directory/
├── README.md
├── Project-Archtecture.png
├── Images/
├── docs/
│   ├── 01-vmware-lab-setup.md
│   ├── 02-active-directory-installation.md
│   ├── 03-ou-and-user-management.md
│   ├── 04-powershell-user-provisioning.md
│   ├── 05-Active Directory Users, Security Groups and Windows 11 Domain Join.md
│   ├── 06-File Server and Access Permissions.md
│   ├── 07-Group Policy Management and Security Filtering.md
│   ├── 08-file-server-permissions.md
│   ├── 09-dns-dhcp.md
│   ├── 10-monitoring-troubleshooting.md
│   ├── 11-backup-recovery.md
│   └── 12-powershell-hybrid-concepts.md
│
└── scripts/
    ├── New-ADUser.ps1
    ├── Import-ADUsersFromCsv.ps1
    └── ...
```

*Note: The script filenames above are examples. Keep the actual filenames in your repository and update this structure to match them. The `Images` folder should contain your existing screenshots.*

## Planned Work

The following tasks are planned for future lab development:

- Complete verification of user attributes and account counts.
- Create department security groups and configure group membership.
- Join the Windows 11 client to the Active Directory domain.
- Configure and test Group Policy Objects (GPOs).
- Configure file shares and NTFS permissions.
- Practise DNS and DHCP administration.
- Practise backup and recovery procedures.
- Analyse Windows event logs and troubleshoot common infrastructure problems.
- Expand PowerShell automation and document test results.

## Security and Lab Notes

- The lab uses fictional company and employee data.
- Passwords and other credentials must not be committed to the public repository.
- Verification results should reflect the actual state of the lab.
- Planned tasks are not presented as completed until they have been configured and tested.
- Screenshots support the documentation; the actual PowerShell scripts are maintained as separate files.

## Project Goal

This project is intended to demonstrate practical knowledge of Windows Server administration, Active Directory, basic DNS concepts, structured user management, PowerShell automation, troubleshooting, and technical documentation.