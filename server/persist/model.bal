// Ballerina Persist Model for Supabase PostgreSQL Integration
// This file defines the data model for the Transparent Governance Platform
// Basic version to get migration working

import ballerina/persist as _;
import ballerina/time;

// User entity - represents platform users with Supabase Auth integration
public type User record {|
    // Primary key - UUID for Supabase compatibility
    readonly string id;
    
    // User identification
    string email;
    string? username;
    string? full_name;
    
    // Supabase Auth integration fields
    string? auth_id; // Maps to Supabase Auth user ID
    string role; // USER, ADMIN, MINISTRY_OFFICIAL, AUDITOR
    
    // Profile information
    string? phone;
    string? address;
    string? organization;
    string? ministry_affiliation;
    
    // Status and metadata
    boolean is_active;
    boolean email_verified;
    
    // Supabase automatic timestamps
    time:Utc created_at;
    time:Utc updated_at;
    
    // Relationships - One-to-many relations only
    BudgetCategory[] created_categories;
    Policy[] authored_policies;
    Proposal[] submitted_proposals;
    Comment[] authored_comments;
    Vote[] votes;
    Notification[] notifications;
    AuditLog[] audit_logs;
    PolicyAmendment[] proposed_amendments;
|};

// Budget Category entity - enhanced for government budget tracking
public type BudgetCategory record {|
    readonly int id;
    
    // Category information
    string category_name;
    string? description;
    
    // Budget allocation and tracking
    decimal allocated_budget;
    decimal spent_budget;
    decimal? reserved_budget;
    
    // Fiscal year and planning
    string fiscal_year;
    string? ministry;
    string? department;
    
    // Status and governance
    string status; // PROPOSED, APPROVED, ACTIVE, SUSPENDED, COMPLETED
    string? approval_authority;
    
    // Transparency and tracking
    string? budget_source;
    string? tracking_code;
    
    // Audit trail
    string created_by_user_id; // Foreign key
    string? last_modified_by_user_id;
    
    // Timestamps
    time:Utc created_at;
    time:Utc updated_at;
    time:Utc? approval_date;
    
    // Foreign key relationship
    User created_by;
    
    // Related entities
    BudgetTransaction[] transactions;
|};

// Policy entity - government policies and regulations
public type Policy record {|
    readonly int id;
    
    // Policy identification
    string name;
    string description;
    string policy_number; // Official policy/regulation number
    
    // Policy content and documentation
    string view_full_policy; // URL or document reference
    
    // Governance and authority
    string ministry;
    string? department;
    string? issuing_authority;
    
    // Status and lifecycle
    string status; // DRAFT, UNDER_REVIEW, APPROVED, ACTIVE, SUSPENDED, REPEALED
    string? policy_type; // REGULATION, DIRECTIVE, GUIDELINE, ACT
    string? priority_level; // HIGH, MEDIUM, LOW
    
    // Implementation and compliance
    time:Utc? effective_date;
    time:Utc? expiry_date;
    string? implementation_status;
    
    // Legal and regulatory
    string? legal_reference;
    string? parent_legislation;
    
    // Transparency and engagement
    boolean public_consultation_required;
    time:Utc? consultation_start_date;
    time:Utc? consultation_end_date;
    
    // Author workflow
    string authored_by_user_id; // Foreign key
    string? approved_by_user_id;
    string? reviewed_by_user_id;
    
    // Timestamps
    time:Utc created_at;
    time:Utc updated_at;
    time:Utc? last_reviewed_date;
    
    // Foreign key relationship
    User authored_by;
    
    // Related entities
    PolicyAmendment[] amendments;
|};

// Policy Amendment entity - tracks changes to policies
public type PolicyAmendment record {|
    readonly string id; // UUID
    
    // Amendment details
    string amendment_title;
    string amendment_description;
    string amendment_type; // ADDITION, MODIFICATION, DELETION, CLARIFICATION
    
    // Policy reference
    int policy_id; // Foreign key
    
    // Amendment content
    string? justification;
    
    // Workflow
    string status; // PROPOSED, UNDER_REVIEW, APPROVED, REJECTED, IMPLEMENTED
    string proposed_by_user_id; // Foreign key
    string? approved_by_user_id;
    
    // Implementation
    time:Utc? effective_date;
    boolean is_emergency_amendment;
    
    // Timestamps
    time:Utc created_at;
    time:Utc updated_at;
    
    // Foreign key relationships
    Policy policy;
    User proposed_by;
|};

// Proposal entity - citizen and organizational proposals
public type Proposal record {|
    readonly string id; // UUID
    
    // Proposal information
    string title;
    string description;
    string proposal_type; // BUDGET_REQUEST, POLICY_SUGGESTION, INFRASTRUCTURE, SOCIAL_PROGRAM
    
    // Categorization
    string? ministry;
    string? department;
    
    // Financial aspects
    decimal? estimated_cost;
    string? funding_source;
    
    // Implementation details
    time:Utc? proposed_start_date;
    time:Utc? proposed_end_date;
    string? implementation_plan;
    
    // Stakeholders and support
    string submitted_by_user_id; // Foreign key
    int votes_for;
    int votes_against;
    int votes_abstain;
    
    // Governance workflow
    string status; // SUBMITTED, UNDER_REVIEW, IN_COMMITTEE, APPROVED, REJECTED, IMPLEMENTED
    string? assigned_reviewer_user_id;
    string? committee_assigned;
    
    // Public engagement
    boolean public_voting_enabled;
    time:Utc? voting_start_date;
    time:Utc? voting_end_date;
    
    // Transparency
    string? impact_assessment;
    
    // Timestamps
    time:Utc created_at;
    time:Utc updated_at;
    time:Utc? last_reviewed_date;
    
    // Foreign key relationship
    User submitted_by;
|};

// Vote entity - voting on proposals and policies
public type Vote record {|
    readonly string id; // UUID
    
    // Vote details
    string vote_type; // FOR, AGAINST, ABSTAIN
    string? vote_reason;
    
    // Voting context
    string votable_type; // PROPOSAL, POLICY, AMENDMENT
    string votable_id; // ID of the item being voted on
    
    // Voter information
    string voter_user_id; // Foreign key
    string? voter_role_at_time; // Role when vote was cast
    
    // Vote metadata
    boolean is_public_vote;
    string? voting_session_id;
    
    // Timestamps
    time:Utc created_at;
    time:Utc? updated_at;
    
    // Foreign key relationship
    User voter;
|};

// Comment entity - comments and discussions
public type Comment record {|
    readonly string id; // UUID
    
    // Comment content
    string content;
    string comment_type; // GENERAL, QUESTION, SUGGESTION, OBJECTION, SUPPORT
    
    // Context
    string commentable_type; // POLICY, PROPOSAL, BUDGET_CATEGORY
    string commentable_id; // ID of the item being commented on
    
    // Thread and hierarchy
    string? parent_comment_id; // For nested comments (managed manually)
    int thread_level; // 0 for top-level, 1+ for nested
    
    // Author information
    string author_user_id; // Foreign key
    boolean is_anonymous;
    
    // Moderation
    string status; // PUBLISHED, PENDING_REVIEW, APPROVED, REJECTED, HIDDEN
    string? moderated_by_user_id;
    string? moderation_reason;
    
    // Engagement
    int likes_count;
    int replies_count;
    boolean is_pinned;
    
    // Timestamps
    time:Utc created_at;
    time:Utc updated_at;
    time:Utc? moderated_at;
    
    // Foreign key relationship
    User author;
|};

// Budget Transaction entity - tracks budget expenditures
public type BudgetTransaction record {|
    readonly string id; // UUID
    
    // Transaction details
    string transaction_type; // ALLOCATION, EXPENDITURE, TRANSFER, ADJUSTMENT, REFUND
    decimal amount;
    string description;
    
    // Transaction references
    int budget_category_id; // Foreign key
    string? transaction_reference; // External reference number
    string? invoice_number;
    string? vendor_information;
    
    // Approval and authorization
    string status; // PENDING, APPROVED, EXECUTED, CANCELLED, REVERSED
    string? approved_by_user_id;
    string? executed_by_user_id;
    
    // Financial tracking
    string? accounting_code;
    string? cost_center;
    
    // Compliance and audit
    string? compliance_status;
    string? audit_notes;
    boolean requires_additional_approval;
    
    // Supporting documentation
    string? attachment_urls;
    
    // Timestamps
    time:Utc created_at;
    time:Utc updated_at;
    time:Utc? transaction_date;
    time:Utc? approval_date;
    time:Utc? execution_date;
    
    // Foreign key relationship
    BudgetCategory budget_category;
|};

// Audit Log entity - comprehensive audit trail
public type AuditLog record {|
    readonly string id; // UUID
    
    // Audit information
    string action; // CREATE, UPDATE, DELETE, APPROVE, REJECT, etc.
    string entity_type; // TABLE/ENTITY name
    string entity_id; // ID of the affected record
    
    // Actor information
    string? user_id; // Foreign key (optional for system actions)
    string? user_role;
    string? ip_address;
    string? user_agent;
    
    // System information
    string? session_id;
    string? transaction_id;
    string? source_system;
    
    // Timestamp
    time:Utc created_at;
    
    // Foreign key relationship
    User user;
|};

// Notification entity - system notifications
public type Notification record {|
    readonly string id; // UUID
    
    // Notification content
    string title;
    string message;
    string notification_type; // INFO, WARNING, ALERT, APPROVAL_REQUEST, etc.
    
    // Targeting
    string recipient_user_id; // Foreign key
    string? channel; // EMAIL, SMS, IN_APP, PUSH
    
    // Context
    string? related_entity_type;
    string? related_entity_id;
    
    // Status
    boolean is_read;
    boolean is_archived;
    string priority; // LOW, MEDIUM, HIGH, URGENT
    
    // Delivery
    time:Utc? scheduled_for;
    time:Utc? sent_at;
    boolean delivery_attempted;
    string? delivery_status;
    
    // Timestamps
    time:Utc created_at;
    time:Utc? read_at;
    
    // Foreign key relationship
    User recipient;
|};