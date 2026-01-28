
## 1) ALL PROCESSES & WORKFLOWS INVOLVED (DATABASE OWNERSHIP SECTION)

### A) Data Ownership Definition Workflow (Governance Setup)

1. Define what data belongs to which system (Career vs ATS).
    
2. Identify “System of Record” for each domain: profile, application, interview, offer.
    
3. Define who can create, update, delete each data type.
    
4. Define audit/logging responsibilities.
    
5. Define legal/compliance rules (PII, retention).
    

**Outcome:** Clear boundaries → no conflict, no duplicate or inconsistent data.

---

### B) Candidate Profile Creation & Storage Workflow

1. Candidate signs up on Career Site.
    
2. Career Site creates Candidate Profile in **Career DB** (master).
    
3. Candidate profile updates (resume/skills/preferences) are stored only in Career DB.
    
4. ATS receives candidate snapshot only when needed (e.g., application submission).
    
5. ATS stores replica in ATS DB for recruitment operations.
    

**Outcome:** Candidate identity is controlled by Career system, recruiters still work efficiently in ATS.

---

### C) Candidate Authentication & Security Workflow

1. Candidate login data is stored in **Career DB** only.
    
2. OTP/password verification happens in Career system.
    
3. ATS never stores candidate password/auth data.
    
4. Recruiter authentication is stored in ATS DB separately.
    
5. Access logs are maintained on both systems.
    

**Outcome:** Security separation reduces breach impact and simplifies compliance.

---

### D) Application Data Ownership Workflow

1. Candidate applies on Career Site.
    
2. Career creates “submission record” + sends application payload to ATS.
    
3. ATS creates Application entity in **ATS DB** (master).
    
4. Career stores only a **read view of application status** for dashboards.
    
5. Application stage updates occur only in ATS.
    

**Outcome:** ATS is the authoritative owner of recruitment workflow lifecycle.

---

### E) Interview & Feedback Data Workflow

1. Recruiter schedules interview in ATS.
    
2. Interview record, panel, feedback stored in **ATS DB** only.
    
3. ATS syncs limited candidate-visible details to Career DB:
    
    - schedule date/time
        
    - mode
        
    - stage updates
        
4. Career DB stores these as read views.
    
5. Candidate sees interview status without exposing feedback/internal comments.
    

**Outcome:** Recruiter-only sensitive data stays in ATS; candidate sees progress transparently.

---

### F) Offer & Joining Data Ownership Workflow

1. Offer is created and approved in ATS.
    
2. Offer record stored in **ATS DB** as master (legal authority).
    
3. Candidate-visible offer PDF/link can be synced to Career DB.
    
4. Joining date and changes remain in ATS DB.
    
5. Candidate sees joining status on Career Site through sync.
    

**Outcome:** Legal documents and approvals remain governed in ATS.

---

### G) Reverse Sync Ownership Workflow (ATS → Career)

1. Recruiter changes stage/status in ATS.
    
2. ATS updates ATS DB.
    
3. ATS generates event: `ApplicationStageChanged`.
    
4. Career DB receives and updates local read views.
    
5. Candidate dashboard displays updated status.
    

**Outcome:** Career site can work even if ATS is temporarily unavailable.

---

### H) Data Conflict Resolution Workflow

1. If Career profile changes → Career wins (SoR).
    
2. If ATS recruiter notes/tags change → ATS wins.
    
3. If both systems update same field (edge case) → rule-based resolution.
    
4. Sync failure events are stored for retry.
    
5. Reconciliation job compares records periodically (optional).
    

**Outcome:** Prevents data inconsistency and supports enterprise reliability.

---

### I) Retention & Deletion Workflow

1. Candidate requests delete profile (Career system).
    
2. Career flags profile as deleted/anonymized.
    
3. ATS receives delete event and anonymizes replicated candidate data.
    
4. Legal retention for applications may still apply (policy-driven).
    
5. Audit logs retained per compliance period.
    

**Outcome:** Supports privacy laws + business needs.

---

---

## 2) TECHNICAL TERMS INVOLVED + BA EXPLANATION (EACH > 5 SENTENCES)

### 1. Database Ownership

Database ownership defines which system is responsible for the correctness and authority of data. From a BA perspective, ownership prevents confusion such as “which system has the correct version.” Ownership determines where updates are allowed and where they are blocked. It also affects audit responsibilities and data retention rules. Without ownership, integrations cause duplication and inconsistency. This section is essential for finalizing scope, testing, and go-live governance.

---

### 2. System of Record (SoR)

System of Record means the system that holds the master, authoritative data for a specific domain. In our case, Career DB is SoR for candidate identity and ATS DB is SoR for recruitment lifecycle data. BA must clearly define SoR for each data type to avoid disputes among teams. SoR impacts integration design because other systems should not overwrite it. SoR also supports compliance—auditors trust the SoR data. If SoR is not defined, sync conflicts and mismatched reporting become unavoidable.

---

### 3. Candidate Profile (Master vs Replica)

Candidate profile contains personal and professional details like name, contact, resume, and skills. In this architecture, the master profile is stored in Career DB, because candidate updates occur there. ATS keeps only a replica to support recruiter operations and search efficiency. BA must specify what fields replicate and what remains exclusive. A replica can be slightly delayed due to event sync, which BA should document as acceptable. This master/replica approach ensures high availability and avoids performance bottlenecks.

---

### 4. Candidate Authentication Data

Authentication data includes password hash, OTP logs, login sessions, and account verification. This must remain only in Career DB because it is part of candidate identity system. BA should define it as restricted, sensitive data requiring encryption and retention policy. ATS should never store candidate passwords because ATS is recruiter-centric. Keeping auth separate reduces security risk and breach surface area. From BA perspective, this also simplifies compliance and reduces integration complexity.

---

### 5. Application Read View

Application read view is the copy of application status stored in Career DB purely for display purposes. It is not editable by the career system. BA should define it as a “projection” or “read-only mirror” of ATS application lifecycle. This ensures candidate dashboard is fast and independent of ATS runtime. If ATS is down, candidate still sees last known status. This concept is crucial to enterprise resilience and performance.

---

### 6. Data Replication

Replication means copying selected data from one system to another. Here, Career profile is replicated to ATS, and ATS status is replicated to Career. BA must define replication scope, frequency, acceptable delay, and ownership boundaries. Replication is required because ATS cannot depend on Career APIs for every recruiter search. Replication also avoids downtime dependency where one system outage breaks the other. BA should specify error handling, retry, and reconciliation requirements.

---

### 7. Event-Driven Sync

Event-driven sync means systems communicate changes using events like “StageChanged” rather than polling. BA must define event catalogue: what events exist, what triggers them, and what payload they carry. Event-driven sync improves performance and system independence. It also introduces eventual consistency, meaning there can be short delays in updates. BA should define SLAs for sync delay (example: 1–5 seconds typical). This method is standard enterprise integration design.

---

### 8. Conflict Resolution Rules

Conflict resolution rules specify what happens when both systems can potentially change the same type of data. BA must define who wins per field type. Example: email and phone belong to Career, recruiter notes belong to ATS. Without conflict rules, sync can overwrite valid information and create support issues. BA should document these rules clearly as business policies. These rules also drive UAT cases and edge scenario testing.

---

### 9. PII (Personally Identifiable Information)

PII is any data that can identify an individual such as name, email, phone, address. BA must classify PII fields and ensure privacy treatment. This ensures encryption, masked display, and restricted access permissions. PII also impacts audit and retention, since it cannot be stored forever without policy. BA must coordinate with legal/compliance if client requires GDPR-like standards. PII handling is a key acceptance criterion for enterprise clients.

---

### 10. Audit Trail

Audit trail records actions such as stage change, offer release, profile updates. BA must define which actions require audit logging and why. Audit trail ensures accountability and compliance. It is especially important in ATS because hiring decisions can be questioned later. Audit data is usually append-only and tamper resistant. BA must define access rules and retention duration for audit logs.

---

### 11. Data Retention Policy

Retention policy defines how long candidate and recruitment data is stored. BA must document retention rules for different statuses: selected, rejected, withdrawn. It must consider privacy requirements and business needs for future hiring. Retention also affects database sizing and archiving strategies. BA must include delete/anonymization workflows. Without retention policy, client may face compliance and storage cost issues.

---

---

## 3) 20 TRICKY & CROSS QUESTIONS (BA 5+ YEARS) — DATABASE OWNERSHIP

1. Why is Career DB the system of record for candidate profiles but ATS stores a candidate replica? Explain the business and technical reasons.
    
2. If candidate edits email after applying, what happens to ATS candidate replica? Does it update automatically?
    
3. If recruiter edits candidate phone number in ATS, should it sync back to Career profile? Why or why not?
    
4. If candidate requests profile deletion, what happens to active applications in ATS?
    
5. How do you handle legal retention when candidate requests deletion but offer documentation must be retained?
    
6. Explain how Career site can show application status if ATS is down.
    
7. What fields are part of “application read view” and why should recruiter-only feedback not be replicated?
    
8. Define the difference between master data and replicated data in this solution.
    
9. How will you ensure replicated data does not become outdated? What is reconciliation strategy?
    
10. What happens if ATS sends stage update event twice? How do you prevent duplicate entries in Career DB?
    
11. How will you handle sync event order issues (Selected arrives before Interview Completed)?
    
12. If two applications exist for same candidate, which table is master for candidate status? Candidate or application?
    
13. What is the ownership of stage/status? Can Career Site change it ever?
    
14. If candidate withdraws application in Career Site, how will it reflect in ATS? Who owns withdrawal?
    
15. Explain how audit logs differ in Career DB vs ATS DB.
    
16. What is the fallback plan if sync integration fails for 24 hours?
    
17. What are the risks of API-only fetch model vs replicated read model for dashboard?
    
18. How will you protect PII when replicating data into ATS DB?
    
19. What is your data retention strategy for rejected candidates across both databases?
    
20. How do you validate that reports generated in ATS match candidate dashboard status shown in Career site?
    


