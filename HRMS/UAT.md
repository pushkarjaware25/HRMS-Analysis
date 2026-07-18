# What is UAT?

**User Acceptance Testing (UAT)** is the **final phase of testing** where **actual business users** verify that the developed system meets the agreed business requirements and is ready for production.

In simple words:

> **"Did we build the right product for the business?"**

Not

> **"Did we build the product correctly?"**

---

# Simple Example

Suppose a company wants an **Online Leave Management System**.

Business Requirement:

> Employees should be able to apply leave.  
> Managers should approve/reject leave.  
> HR should generate leave reports.

Developers build it.

QA team tests whether buttons work, validations work, database updates correctly, etc.

Everything passes.

Now HR and Managers use the application.

They say:

> "Manager should receive an email."

But no email comes.

Technically everything works.

Business says:

> "This system cannot go live."

This is exactly why UAT exists.

---

# Purpose of UAT

UAT verifies:

✅ Business requirements are fulfilled

✅ Business process works

✅ End users are satisfied

✅ Application is usable

✅ No major business issues exist

After successful UAT,

Business gives

> **Sign-Off**

Only after sign-off is the application deployed to Production.

---

# Where UAT Comes in SDLC

```
Requirement Gathering
        ↓
Analysis
        ↓
Design
        ↓
Development
        ↓
System Testing
        ↓
Integration Testing
        ↓
Regression Testing
        ↓
User Acceptance Testing (UAT)
        ↓
Production
```

---

# Difference Between QA Testing and UAT

|QA Testing|UAT|
|---|---|
|Done by QA Team|Done by Business Users|
|Checks functionality|Checks business expectations|
|Technical validation|Business validation|
|Finds software defects|Finds business process gaps|
|Happens before UAT|Final testing stage|
|"Did we build it correctly?"|"Did we build the right thing?"|

---

# Real Banking Example

Requirement:

Customer transfers money.

Expected Flow:

```
Enter Account
↓
Enter Amount
↓
OTP
↓
Transfer Successful
↓
SMS
↓
Email
↓
Transaction History Updated
```

QA tests:

✔ OTP works

✔ Amount deducted

✔ Database updated

Everything passes.

Business User performs UAT.

They notice:

> Transaction history shows old balance.

Business rejects.

Reason:

Business requirement failed.

---

# BA's Role in UAT

This is one of the most important interview topics.

A Business Analyst usually **coordinates and supports** UAT rather than executing all tests.

Responsibilities include:

### Before UAT

- Ensure BRD/FRD/User Stories are finalized.
    
- Confirm all requirements are implemented.
    
- Prepare or review UAT scenarios.
    
- Create UAT test cases (or help prepare them).
    
- Arrange UAT environment.
    
- Identify business users.
    
- Conduct UAT planning meetings.
    
- Prepare test data.
    
- Define acceptance criteria.
    

---

### During UAT

- Support business users.
    
- Explain requirements.
    
- Clarify business rules.
    
- Track defects.
    
- Prioritize issues.
    
- Coordinate with QA and developers.
    
- Ensure critical defects are fixed.
    
- Update stakeholders on progress.
    

---

### After UAT

- Verify defect fixes.
    
- Obtain business sign-off.
    
- Archive UAT documents.
    
- Support Go-Live planning.
    
- Prepare release notes if needed.
    

---

# BA Deliverables During UAT

A BA may prepare or review:

- UAT Test Plan
    
- UAT Test Cases
    
- Test Data
    
- Requirement Traceability Matrix (RTM)
    
- Defect Log
    
- UAT Status Report
    
- Business Sign-Off Document
    

---

# UAT Lifecycle

```
Requirements Approved
        ↓
Create UAT Plan
        ↓
Identify Business Users
        ↓
Prepare UAT Test Cases
        ↓
Prepare Test Data
        ↓
Execute UAT
        ↓
Log Defects
        ↓
Fix Defects
        ↓
Retest
        ↓
Business Sign-Off
        ↓
Go Live
```

---

# What is a UAT Test Case?

Example:

Requirement:

Employee should apply leave.

|Test Case ID|UAT-001|
|---|---|
|Requirement|Apply Leave|
|Steps|Login → Apply Leave|
|Test Data|Casual Leave|
|Expected Result|Leave Submitted Successfully|
|Actual Result|Pass|
|Status|Pass|

---

# What is UAT Test Data?

Test data is realistic information used during testing.

Example:

Employee ID

```
EMP101
```

Leave Balance

```
15 Days
```

Manager

```
John
```

Department

```
IT
```

---

# What is UAT Environment?

A separate environment similar to Production.

```
Development
        ↓
QA
        ↓
UAT
        ↓
Production
```

Business users should never test in Production.

---

# What Happens if UAT Fails?

Business users report issues.

Example:

Issue:

> Approval email is not sent.

Developer fixes.

QA retests.

Business retests.

If satisfied,

UAT passes.

---

# Common UAT Defects

- Incorrect workflow
    
- Missing business rule
    
- Wrong calculations
    
- Incorrect reports
    
- Missing notifications
    
- Wrong access permissions
    
- Poor usability
    
- Missing validations
    
- Incorrect approval flow
    
- Data mismatch
    

---

# What is UAT Sign-Off?

After successful testing, the business confirms the application is acceptable.

Example:

```
Project: Leave Management

Business Representative:

"I confirm all agreed business requirements
have been tested successfully and approve
the application for Production."

Name:
Signature:
Date:
```

Without sign-off, production deployment is usually not approved.

---

# Real Interview Example

Imagine you're implementing an **HRMS Recruitment System** (similar to the one you've been studying).

**Requirement:**

- Candidate applies on the Career Portal.
    
- Recruiter sees the application in the ATS.
    
- Interview is scheduled.
    
- Candidate receives an email.
    
- Candidate can view the interview status on the portal.
    

**Sample UAT scenarios:**

|Scenario|Expected Result|
|---|---|
|Candidate submits application|Application created successfully|
|Recruiter opens ATS|Candidate appears in recruiter queue|
|Recruiter schedules interview|Candidate receives interview email|
|Candidate logs into portal|Updated interview status is visible|
|Recruiter rejects candidate|Candidate sees "Rejected" status and notification (if required by business rules)|

These scenarios validate the **end-to-end business process**, not just individual technical functions.

---

# Frequently Asked Interview Questions on UAT

1. What is UAT, and why is it important?
    
2. What is the difference between QA testing and UAT?
    
3. Who performs UAT?
    
4. What is the BA's role during UAT?
    
5. What documents are used in UAT?
    
6. What is UAT sign-off?
    
7. How do you prepare UAT test cases?
    
8. What do you do if a business user raises a defect during UAT?
    
9. What is the difference between SIT and UAT?
    
10. How do you decide when UAT is complete?
    

### A concise interview answer

> "User Acceptance Testing is the final validation phase where business users verify that the application satisfies business requirements and supports their real-world processes. As a Business Analyst, I help prepare UAT scenarios and test data, coordinate business users, clarify requirements, manage defect triage with QA and development teams, verify fixes, and obtain business sign-off before production deployment. My focus is ensuring the solution delivers the intended business value, not just that it is technically correct."