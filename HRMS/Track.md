# System Architecture for the Cluster Points Recruitment Platform

## Executive Summary

This document outlines the system architecture for the **Cluster Points Recruitment Platform**, a unified hiring solution designed for **enterprise‑grade scalability, fault tolerance, and operational clarity**.

The platform is fundamentally a **two‑module system**:

- **Module 1:** Candidate‑facing **Career Website**
    
- **Module 2:** Recruiter‑facing **Applicant Tracking System (ATS)** (functionally similar to Zoho Recruit)
    

A strict **separation of concerns** governs the architecture. Each module is the authoritative **System of Record (SoR)** for a specific data domain:

- The **Career Website** is the System of Record for **Candidate Profiles**.
    
- The **ATS** is the System of Record for the **Application Lifecycle**.
    

This non‑negotiable ownership model prevents data conflicts and operational ambiguity.

Instead of fragile real‑time API dependencies for UI data, the platform uses an **event‑driven, asynchronous replication model**. Data is synchronized using **REST APIs, webhooks, and message queues**, ensuring that failure in one module never incapacitates the other.

Key architectural decisions—such as treating **Candidates and Applications as separate entities** and adopting an **application‑centric search model**—are mandatory to support **high‑volume recruitment operations** efficiently.

---

## Core Architectural Principles

The platform design is governed by the following foundational principles:

- **Defined Ownership**
    
    - Career Site owns the **Candidate Profile**.
        
    - ATS owns the **Application Lifecycle**.
        
    - No circular or shared ownership.
        
- **Data Synchronization over Runtime Dependency**
    
    - Each module stores local, synchronized **read models**.
        
    - UI never depends on another module at runtime.
        
- **Operational Independence**
    
    - Each module functions independently.
        
    - Failure of one does not block core operations of the other.
        
- **Event‑Driven Communication**
    
    - All synchronization occurs via events (REST + webhooks).
        
    - Retry mechanisms and Dead‑Letter Queues (DLQs) prevent data loss.
        
- **Separation of Entities**
    
    - _Candidate_ and _Application_ are distinct entities.
        
    - Mandatory for handling multi‑application scenarios.
        
- **Context‑Driven Communication**
    
    - The system that owns an action sends the corresponding communication (emails, notifications).
        

---

## System Overview: Two‑Module Architecture

### Module 1: Career Website (Candidate System of Record)

The Career Website is the **single candidate‑facing entry point** for all job applications, whether sourced directly or via partner portals (e.g., Naukri, Indeed).

#### Primary Responsibilities

- Candidate registration, authentication, and profile management
    
- Job discovery, search, and browsing
    
- Partner portal redirects and application pre‑fill handling
    
- Application submission and confirmation
    
- Candidate dashboard for real‑time application tracking
    

#### Database Philosophy

- **Database:** `clusterpoints_career_db`
    
- Optimized for **fast reads** and candidate UX
    
- Stores:
    
    - Master copy of candidate profiles
        
    - Read‑only, synchronized views of application statuses from ATS
        

---

### Module 2: Applicant Tracking System (ATS) (Recruitment System of Record)

The ATS is the **internal recruiter‑facing system** managing the full recruitment lifecycle.

#### Primary Responsibilities

- Job posting management and hiring manager assignments
    
- Candidate pipeline management (Applied → Interview → Offer → Hired)
    
- Advanced resume and application search (Elasticsearch/OpenSearch)
    
- Interview scheduling, feedback capture, and panel management
    
- Offer generation and approval workflows
    
- Joining date management and onboarding initiation
    
- Recruitment analytics and reporting (e.g., time‑to‑hire)
    

#### Database Philosophy

- **Database:** `clusterpoints_ats_db`
    
- Optimized for recruiter operations and analytics
    
- Stores:
    
    - Authoritative application, interview, and offer data
        
    - Replicated candidate profile data for fast, independent search and reporting
        

---

## Data Ownership and Synchronization Strategy

### System of Record Matrix

|Data Domain|Authoritative Owner|Synced To|
|---|---|---|
|Candidate Profile & Identity|Career Site|ATS (Replica)|
|Resume|Career Site|ATS (Replica)|
|Application Lifecycle & Status|ATS|Career Site (Read View)|
|Interview Data|ATS|Career Site (Read View)|
|Offer Data|ATS|Career Site (Read View)|
|Candidate Dashboard View|Career Site|N/A|

Runtime dependency for critical UI data is **explicitly forbidden**.

---

## Event‑Driven Synchronization Mechanism

### Forward Sync (Career → ATS)

- Trigger: Candidate submits an application
    
- Event: `ApplicationCreated`
    
- Payload includes:
    
    - Candidate profile snapshot
        
    - Resume
        

### Reverse Sync (ATS → Career)

- Trigger: Application stage change (e.g., Interview Scheduled)
    
- Event: `ApplicationStageChanged`
    
- Mechanism: Webhook to Career Site
    
- Result: Update read‑only application status
    

### Failure Handling

- Failed events enter a **retry queue** with exponential backoff
    
- Persistently failing events move to a **Dead‑Letter Queue (DLQ)**
    
- Events can be manually investigated and replayed
    

### Idempotency

- Every event includes `eventId` and version
    
- Receiving systems track processed versions
    
- Duplicate or redundant events are safely ignored
    

---

## Key Design Decisions (Non‑Negotiable)

### 1. Candidate vs Application as Separate Entities

- One candidate can apply to multiple jobs
    
- Each application has its own lifecycle
    
- Rejection in one application does not affect others
    
- Reporting and workflows are application‑centric
    

---

### 2. Application‑Centric Search in the ATS

- Recruiters search **Applications**, not Candidates
    
- Search index is built around the **Application entity**
    
- Embedded candidate attributes: name, skills, experience
    

**Example Query:**

> “Candidates who applied for _Java Developer_ and are in _L2 Interview_ stage”

Executed via a single, fast search query.

---

### 3. Replication over Runtime API Calls

#### Candidate Profile Replication

- ATS stores replicated candidate profiles
    
- Rejected: API‑only model calling Career Site at runtime
    
- Reasons: latency, fragility, reporting limitations
    

#### Application Status Replication

- Career Site stores read‑only application status
    
- Rejected: real‑time ATS calls for candidate dashboard
    
- Reasons: slow UX, full dependency on ATS availability
    

---

### 4. Context‑Driven Email Ownership

**Golden Rule:** The system that owns the action sends the email.

|Email Type|Sent By|Rationale|
|---|---|---|
|Signup / Login OTP|Career Site|Candidate identity action|
|Application Submitted|Career Site|Immediate candidate UX feedback|
|Interview Scheduled / Rescheduled|ATS|Recruiter workflow ownership|
|Offer Released|ATS|Legal and process authority|

---

## Enterprise‑Grade Features

### Scalability Strategy

- **Horizontal Scaling:** Stateless services enable easy scale‑out
    
- **Asynchronous Processing:** Resume parsing, emails via Kafka
    
- **Read Replicas:** Analytics workloads isolated from writes
    
- **Search Indexing:** Elasticsearch/OpenSearch for high‑speed queries
    

---

### Fault Tolerance

**If ATS is Down:**

- Career Site remains operational
    
- Applications queued and synced after recovery
    
- Dashboard shows last known statuses
    

**If Career Site is Down:**

- ATS continues recruiter operations
    
- Reverse sync events queued and replayed post‑recovery
    

---

### Security

- **Authentication & Authorization:** OAuth2, JWT, RBAC
    
- **Data Protection:** HTTPS in transit, AES‑256 encryption at rest
    
- **Integration Security:** API keys, webhook signature validation
    
- **Auditability:** Immutable audit logs for all critical hiring actions
    

---

**End of Architecture Briefing**