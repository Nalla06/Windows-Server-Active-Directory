## 7A-Group Policy Management and User Restrictions

#### 1. Project Overview

This part of the TechOffice GmbH Windows Server administration lab demonstrates how to create, link, configure, apply, and verify Group Policy Objects (GPOs) in an Active Directory domain.

The first half focuses on applying user restrictions through a GPO linked to the Company organizational unit (OU). The second half will extend the lab by targeting selected users through security groups and Group Policy security filtering.

#### 2. Lab Environment

| Component | Configuration |
|---|---|
| Company | TechOffice GmbH |
| Server operating system | Windows Server 2025 |
| Server hostname | SRV-DC01 |
| Active Directory domain | ad.techoffice.test |
| Active Directory OU | Company |
| Group Policy Object (GPO) | GPO-TechOffice-User-Baseline |
| GPO link location | Company OU |
| GPO status | Enabled |
| Security filtering | Authenticated Users |
| User policy 1 | Prevent changing desktop background |
| User policy 2 | Prohibit access to Control Panel and PC settings |
| Client operating system | Windows 11 |
| Client computer role | Domain-joined workstation |
| Test user | Julia Schulz (AD\julia.schulz) |
| Policy verification | `gpupdate` and `gpresult /r` |
| Targeted GPO exercise | Planned — Security Filtering for selected users |


#### 3. Objectives

Create and link a Group Policy Object to an organizational unit.
Configure user-specific administrative template policies.
Refresh Group Policy on a Windows 11 domain client.
Verify policy application using gpresult.
Test the configured restrictions with a domain user account.
Understand the difference between OU-based GPO linking and security filtering.
Prepare a separate exercise for applying policies to selected users across departments.

#### 4. GPO Creation and Configuration

##### 4.1 Create the GPO

The GPO GPO-TechOffice-User-Baseline was created through Group Policy Management on SRV-DC01 and linked to the Company OU.
The GPO link was verified as enabled. The GPO status was also confirmed as enabled, and Authenticated Users was present in Security Filtering.
Because the GPO is linked to the parent Company OU, its applicable user settings can be inherited by user accounts in child OUs, provided normal Group Policy scope and permission requirements are satisfied.

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-48.png)

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-49.png)

##### 4.2 Configure the desktop background restriction

The following user policy was configured:

Policy: Prevent changing desktop background
Location:
User Configuration → Policies → Administrative Templates → Control Panel → Personalization
Configuration: Enabled
This setting restricts users covered by the GPO from changing their desktop background through the normal Windows personalization interface.

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-51.png)

##### 4.3 Configure the Control Panel and Settings restriction

The following user policy was also configured:
Policy: Prohibit access to Control Panel and PC settings
Configuration: Enabled
This policy restricts access to Control Panel and the Windows Settings app for users covered by the GPO.
Both policies were configured under User Configuration, because the intention was to apply the restrictions to user accounts rather than to a particular computer.

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-54.png)

#### 5. Applying and Verifying Group Policy

##### 5.1 Refresh user policy

On the Windows 11 client, signed in with Julia Schulz's domain account, the following command was used:
gpupdate /target:user /force
The user policy update completed successfully.

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-55.png)

##### 5.2 Verify the applied GPO

The following command was used to inspect the resulting policy information:
gpresult /r

The output showed:
User: AD\julia.schulz
Group Policy applied from: SRV-DC01.ad.techoffice.test
Applied Group Policy Objects: GPO-TechOffice-User-Baseline
This confirmed that the GPO was being applied to Julia's user account.

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-52.png)

#### 6. Functional Testing

###### Test 1 — Desktop background restriction

Procedure: Signed in as Julia and opened the Windows personalization settings.
Expected result: Julia should not be able to change the desktop background through the normal personalization interface.
Observed result: The desktop background restriction worked as expected.
Status: Passed

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-53.png)

###### Test 2 — Control Panel and Settings restriction

Procedure: Attempted to access Control Panel and Windows Settings while signed in as Julia.
Expected result: Access should be restricted by the configured user policy.
Observed result: Windows displayed a restriction message indicating that the operation was restricted and that an administrator should be contacted.
Status: Passed

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-56.png)

#### 7. Understanding GPO Scope

The GPO is linked to the Company OU and has Authenticated Users in Security Filtering. Therefore, its user settings are not intended for Julia alone. They can apply to other in-scope user accounts under the Company OU as well.
The scope of a GPO is influenced by its link location, inheritance, security filtering, permissions, and any applicable policy-processing settings.
A GPO linked to an OU does not automatically target a single user. To apply a different set of restrictions to selected users, a separate GPO with suitable security filtering can be used.

## 7B – Targeted Group Policy Deployment Using Security Filtering

#### 1. Objective

In Part 7A, I created a baseline Group Policy Object (GPO) to apply common user restrictions across the TechOffice GmbH environment.

In Part 7B, I extended the lab to demonstrate how additional policies can be targeted at selected users through Active Directory security groups.

The objective was to understand how Group Policy can apply different settings to different users without creating separate policies for every department or user account.

#### 2. Why This Is Important in a Real Company

In a company, not every user needs the same restrictions or configuration. For example:
Standard employees may receive common desktop and security settings.
IT administrators may need access to additional management tools.
Users handling sensitive financial or HR data may require additional restrictions.
Selected users may need specific application or desktop configurations.
Security groups help administrators manage these requirements centrally. Instead of configuring each user individually, an administrator can add or remove users from the appropriate group.

Key concept: The security group identifies who should receive a policy, while the GPO defines what the policy does.

#### 3. Implementation

###### Step 1 – Create a security group

Created GG-Restricted-Users under:
Company → Groups
The group was configured as a Global security group.

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-57.png)

###### Step 2 – Add a target user

Added Julia Schulz (julia.schulz) to GG-Restricted-Users.
Julia remained a member of her existing department group, GG-IT.

This demonstrates that one Active Directory user can belong to multiple security groups, each serving a different administrative purpose.

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-58.png)

###### Step 3 – Create a separate GPO

Created and linked GPO-Restricted-Users to the Company OU.
The existing baseline GPO was left unchanged.

###### Step 4 – Configure a test policy

Configured the following user policy:
User Configuration → Policies → Administrative Templates → Start Menu and Taskbar → Remove Run menu from Start Menu
Set the policy to Enabled.
This setting was selected as a visible test of targeted policy deployment.

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-60.png) 

###### Step 5 – Configure Security Filtering

Configured the GPO's Security Filtering to target:
GG-Restricted-Users
Checked the GPO permissions to ensure the target group had the required Read and Apply Group Policy permissions.

The GPO must also remain readable by the relevant computer accounts. Read permission alone does not cause a user to receive a GPO.

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-62.png)

#### 4. Testing and Verification

On the Windows 11 client, signed in as Julia Schulz and refreshed Group Policy:
gpupdate /force
Checked the resulting policy application:
gpresult /r
Verified the following
GPO-TechOffice-User-Baseline appeared in the applied user policies.
GPO-Restricted-Users appeared in the applied user policies.
The baseline policy prevented access to Windows Settings and Control Panel.
The targeted policy removed the Run command as configured.

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-63.png) 

#### 5. Result

The test confirmed that Julia received both the baseline policy and the additional targeted policy.

This demonstrates how an Active Directory user can receive multiple GPOs and how a security group can be used to target an additional policy.

Testing limitation: The policy has been verified for a group member. A separate test with a user who is not a member of GG-Restricted-Users is still required to verify that the targeted GPO is excluded for non-members.

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-64.png)

#### 6. Key Learning Notes

A security group does not restrict users by itself; the GPO defines the restriction.
A user can belong to multiple security groups.
A GPO must be linked at an appropriate point in the user's OU path.
Security Filtering controls which security principals can apply the GPO, subject to the GPO's permissions and other Group Policy processing rules.
Separating baseline policies from targeted policies makes administration easier to manage and troubleshoot.
gpupdate /force refreshes Group Policy, while gpresult /r helps verify the policies applied to a user.

#### 7. Real-World Application

In a production environment, an administrator might use a baseline GPO for common company settings and separate security groups to target additional configurations for particular teams or user populations.

For example, a restricted-user group could be used to deploy a specific user configuration to designated accounts. Actual security controls should be selected according to company requirements and tested before production deployment.

This lab demonstrates the basic administrative workflow: create a security group, add users, configure a GPO, apply security filtering, and verify the result.


###  7C – Verify Security Filtering with a Non-Member User

#### 1. Objective

The objective of this test was to verify that a Group Policy Object (GPO) configured for a specific security group applies only to eligible members of that group.

For this test, Johanna Kaiser was used as a comparison user. He was a member of the default Domain Users group but was not a member of GG-Restricted-Users.

This test demonstrates how Active Directory security groups and Group Policy security filtering can be used to apply different user restrictions to different employees.

#### 2. Why Did Johanna Receive the Baseline GPO?

Johanna received GPO-TechOffice-User-Baseline because the GPO was linked to the Company OU, and her user account was located within that OU's hierarchy.
The OU structure was:
ad.techoffice.test
└── Company
    ├── Users
    │   ├── Julia Schulz
    │   └── Johanna Kaiser
    ├── Computers
    ├── Groups
    └── Servers

Because Johanna's user account was inside Company → Users, the baseline GPO linked to the parent Company OU was within her user account's Group Policy scope.
The baseline GPO was security-filtered for Authenticated Users, allowing eligible authenticated users to apply its settings, subject to the GPO's permissions and other processing conditions.
The baseline GPO contained these user restrictions:
Prevent changing the desktop background.
Prohibit access to Control Panel and PC settings.
Important: The baseline GPO was not assigned specifically to Johanna. It was linked to the Company OU, so other eligible user accounts in that OU hierarchy could receive it too.

#### 3. Why Did Johanna Not Receive the Restricted-User GPO?

The GPO-Restricted-Users GPO was also linked to the Company OU, but its Security Filtering was configured for the group GG-Restricted-Users.
Julia Schulz was a member of this group, while Johanna Kaiser was not.
Therefore, Johanna did not meet the security-filtering requirement for the restricted-user GPO.
That GPO contained the following setting:
User Configuration → Policies → Administrative Templates → Start Menu and Taskbar → Remove Run menu from Start Menu
The policy was intended to restrict the Run command for users belonging to the designated security group.
This demonstrates that linking a GPO to an OU determines its potential scope, while security filtering determines which eligible users or computers are permitted to apply it.

#### 4. Verification on the Windows 11 Client

The following commands were used to refresh Group Policy and review the applied policies.
Refresh Group Policy:
gpupdate /force
Display the applied user and computer policies:
gpresult /r

![Windows Server Active Directory Lab Architecture](../Images/Screenshot-65.png)

#### 5. Understanding Group Policy Scope

Group Policy processing depends on several factors:
OU placement: Determines which OU-linked GPOs are within scope.
GPO links: A GPO linked to a parent OU can apply to eligible objects in child OUs.
Security filtering: Controls which users or computers can apply a GPO.
Permissions: The relevant security principal must have the required Read and Apply Group Policy permissions.
Inheritance and other conditions: Blocked inheritance, enforced links, WMI filters, and other processing conditions can affect the result.
A user outside the Company OU does not automatically receive the GPOs linked only to that OU. However, they may still receive policies linked to the domain root, another OU in their path, or their local computer.
User settings and computer settings also have different scopes: user settings normally follow the user account's OU path, while computer settings follow the computer account's OU path. Loopback processing can modify how user settings are processed on a computer.

#### 8.Key Learning

This exercise demonstrated how to:
Link a baseline GPO to an OU.
Apply a separate GPO to a selected security group.
Verify policy application using gpupdate and gpresult.
Compare results between a group member and a non-member.
Distinguish OU-based GPO scope from security filtering.
Troubleshoot policy results without confusing baseline restrictions with targeted restrictions.

