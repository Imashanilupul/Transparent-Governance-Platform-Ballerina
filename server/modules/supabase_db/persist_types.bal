// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/time;

public type User record {|
    readonly string id;
    string email;
    string? username;
    string? full_name;
    string? auth_id;
    string role;
    string? phone;
    string? address;
    string? organization;
    string? ministry_affiliation;
    boolean is_active;
    boolean email_verified;
    time:Utc created_at;
    time:Utc updated_at;

|};

public type UserOptionalized record {|
    string id?;
    string email?;
    string? username?;
    string? full_name?;
    string? auth_id?;
    string role?;
    string? phone?;
    string? address?;
    string? organization?;
    string? ministry_affiliation?;
    boolean is_active?;
    boolean email_verified?;
    time:Utc created_at?;
    time:Utc updated_at?;
|};

public type UserWithRelations record {|
    *UserOptionalized;
    BudgetCategoryOptionalized[] categories?;
    PolicyOptionalized[] authored_policies?;
    ProposalOptionalized[] proposals?;
    CommentOptionalized[] comments?;
    VoteOptionalized[] votes?;
    PolicyAmendmentOptionalized[] proposed_amendments?;
|};

public type UserTargetType typedesc<UserWithRelations>;

public type UserInsert User;

public type UserUpdate record {|
    string email?;
    string? username?;
    string? full_name?;
    string? auth_id?;
    string role?;
    string? phone?;
    string? address?;
    string? organization?;
    string? ministry_affiliation?;
    boolean is_active?;
    boolean email_verified?;
    time:Utc created_at?;
    time:Utc updated_at?;
|};

public type BudgetCategory record {|
    readonly int id;
    string category_name;
    string? description;
    decimal allocated_budget;
    decimal spent_budget;
    decimal? reserved_budget;
    string fiscal_year;
    string? ministry;
    string? department;
    string status;
    string? approval_authority;
    string? budget_source;
    string? tracking_code;
    string? budget_breakdown_json;
    string created_by_user_id;
    string? last_modified_by_user_id;
    time:Utc created_at;
    time:Utc updated_at;
    time:Utc? approval_date;
    string created_byId;

|};

public type BudgetCategoryOptionalized record {|
    int id?;
    string category_name?;
    string? description?;
    decimal allocated_budget?;
    decimal spent_budget?;
    decimal? reserved_budget?;
    string fiscal_year?;
    string? ministry?;
    string? department?;
    string status?;
    string? approval_authority?;
    string? budget_source?;
    string? tracking_code?;
    string? budget_breakdown_json?;
    string created_by_user_id?;
    string? last_modified_by_user_id?;
    time:Utc created_at?;
    time:Utc updated_at?;
    time:Utc? approval_date?;
    string created_byId?;
|};

public type BudgetCategoryWithRelations record {|
    *BudgetCategoryOptionalized;
    UserOptionalized created_by?;
    BudgetTransactionOptionalized[] transactions?;
    CommentOptionalized[] comments?;
|};

public type BudgetCategoryTargetType typedesc<BudgetCategoryWithRelations>;

public type BudgetCategoryInsert BudgetCategory;

public type BudgetCategoryUpdate record {|
    string category_name?;
    string? description?;
    decimal allocated_budget?;
    decimal spent_budget?;
    decimal? reserved_budget?;
    string fiscal_year?;
    string? ministry?;
    string? department?;
    string status?;
    string? approval_authority?;
    string? budget_source?;
    string? tracking_code?;
    string? budget_breakdown_json?;
    string created_by_user_id?;
    string? last_modified_by_user_id?;
    time:Utc created_at?;
    time:Utc updated_at?;
    time:Utc? approval_date?;
    string created_byId?;
|};

public type Policy record {|
    readonly int id;
    string name;
    string description;
    string policy_number;
    string view_full_policy;
    string? policy_document_json;
    string ministry;
    string? department;
    string? issuing_authority;
    string status;
    string? policy_type;
    string? priority_level;
    time:Utc? effective_date;
    time:Utc? expiry_date;
    string? implementation_status;
    string? legal_reference;
    string? parent_legislation;
    string? affected_sectors_json;
    boolean public_consultation_required;
    time:Utc? consultation_start_date;
    time:Utc? consultation_end_date;
    string authored_by_user_id;
    string? approved_by_user_id;
    string? reviewed_by_user_id;
    string? tags_json;
    string? metadata_json;
    time:Utc created_at;
    time:Utc updated_at;
    time:Utc? last_reviewed_date;
    string authored_byId;

|};

public type PolicyOptionalized record {|
    int id?;
    string name?;
    string description?;
    string policy_number?;
    string view_full_policy?;
    string? policy_document_json?;
    string ministry?;
    string? department?;
    string? issuing_authority?;
    string status?;
    string? policy_type?;
    string? priority_level?;
    time:Utc? effective_date?;
    time:Utc? expiry_date?;
    string? implementation_status?;
    string? legal_reference?;
    string? parent_legislation?;
    string? affected_sectors_json?;
    boolean public_consultation_required?;
    time:Utc? consultation_start_date?;
    time:Utc? consultation_end_date?;
    string authored_by_user_id?;
    string? approved_by_user_id?;
    string? reviewed_by_user_id?;
    string? tags_json?;
    string? metadata_json?;
    time:Utc created_at?;
    time:Utc updated_at?;
    time:Utc? last_reviewed_date?;
    string authored_byId?;
|};

public type PolicyWithRelations record {|
    *PolicyOptionalized;
    UserOptionalized authored_by?;
    CommentOptionalized[] comments?;
    PolicyAmendmentOptionalized[] amendments?;
|};

public type PolicyTargetType typedesc<PolicyWithRelations>;

public type PolicyInsert Policy;

public type PolicyUpdate record {|
    string name?;
    string description?;
    string policy_number?;
    string view_full_policy?;
    string? policy_document_json?;
    string ministry?;
    string? department?;
    string? issuing_authority?;
    string status?;
    string? policy_type?;
    string? priority_level?;
    time:Utc? effective_date?;
    time:Utc? expiry_date?;
    string? implementation_status?;
    string? legal_reference?;
    string? parent_legislation?;
    string? affected_sectors_json?;
    boolean public_consultation_required?;
    time:Utc? consultation_start_date?;
    time:Utc? consultation_end_date?;
    string authored_by_user_id?;
    string? approved_by_user_id?;
    string? reviewed_by_user_id?;
    string? tags_json?;
    string? metadata_json?;
    time:Utc created_at?;
    time:Utc updated_at?;
    time:Utc? last_reviewed_date?;
    string authored_byId?;
|};

public type BudgetTransaction record {|
    readonly string id;
    string transaction_type;
    decimal amount;
    string description;
    int budget_category_id;
    string? transaction_reference;
    string? invoice_number;
    string? vendor_information;
    string status;
    string? approved_by_user_id;
    string? executed_by_user_id;
    string? accounting_code;
    string? cost_center;
    string? line_items_json;
    string? compliance_status;
    string? audit_notes;
    boolean requires_additional_approval;
    string? supporting_documents_json;
    string? attachment_urls;
    time:Utc created_at;
    time:Utc updated_at;
    time:Utc? transaction_date;
    time:Utc? approval_date;
    time:Utc? execution_date;
    int budget_categoryId;
|};

public type BudgetTransactionOptionalized record {|
    string id?;
    string transaction_type?;
    decimal amount?;
    string description?;
    int budget_category_id?;
    string? transaction_reference?;
    string? invoice_number?;
    string? vendor_information?;
    string status?;
    string? approved_by_user_id?;
    string? executed_by_user_id?;
    string? accounting_code?;
    string? cost_center?;
    string? line_items_json?;
    string? compliance_status?;
    string? audit_notes?;
    boolean requires_additional_approval?;
    string? supporting_documents_json?;
    string? attachment_urls?;
    time:Utc created_at?;
    time:Utc updated_at?;
    time:Utc? transaction_date?;
    time:Utc? approval_date?;
    time:Utc? execution_date?;
    int budget_categoryId?;
|};

public type BudgetTransactionWithRelations record {|
    *BudgetTransactionOptionalized;
    BudgetCategoryOptionalized budget_category?;
|};

public type BudgetTransactionTargetType typedesc<BudgetTransactionWithRelations>;

public type BudgetTransactionInsert BudgetTransaction;

public type BudgetTransactionUpdate record {|
    string transaction_type?;
    decimal amount?;
    string description?;
    int budget_category_id?;
    string? transaction_reference?;
    string? invoice_number?;
    string? vendor_information?;
    string status?;
    string? approved_by_user_id?;
    string? executed_by_user_id?;
    string? accounting_code?;
    string? cost_center?;
    string? line_items_json?;
    string? compliance_status?;
    string? audit_notes?;
    boolean requires_additional_approval?;
    string? supporting_documents_json?;
    string? attachment_urls?;
    time:Utc created_at?;
    time:Utc updated_at?;
    time:Utc? transaction_date?;
    time:Utc? approval_date?;
    time:Utc? execution_date?;
    int budget_categoryId?;
|};

public type Comment record {|
    readonly string id;
    string content;
    string comment_type;
    string commentable_type;
    string commentable_id;
    string? parent_comment_id;
    int thread_level;
    string author_user_id;
    boolean is_anonymous;
    string status;
    string? moderated_by_user_id;
    string? moderation_reason;
    int likes_count;
    int replies_count;
    boolean is_pinned;
    time:Utc created_at;
    time:Utc updated_at;
    time:Utc? moderated_at;
    string authorId;
    int policyId;
    int budget_categoryId;
    string proposalId;
|};

public type CommentOptionalized record {|
    string id?;
    string content?;
    string comment_type?;
    string commentable_type?;
    string commentable_id?;
    string? parent_comment_id?;
    int thread_level?;
    string author_user_id?;
    boolean is_anonymous?;
    string status?;
    string? moderated_by_user_id?;
    string? moderation_reason?;
    int likes_count?;
    int replies_count?;
    boolean is_pinned?;
    time:Utc created_at?;
    time:Utc updated_at?;
    time:Utc? moderated_at?;
    string authorId?;
    int policyId?;
    int budget_categoryId?;
    string proposalId?;
|};

public type CommentWithRelations record {|
    *CommentOptionalized;
    UserOptionalized author?;
    PolicyOptionalized policy?;
    BudgetCategoryOptionalized budget_category?;
    ProposalOptionalized proposal?;
|};

public type CommentTargetType typedesc<CommentWithRelations>;

public type CommentInsert Comment;

public type CommentUpdate record {|
    string content?;
    string comment_type?;
    string commentable_type?;
    string commentable_id?;
    string? parent_comment_id?;
    int thread_level?;
    string author_user_id?;
    boolean is_anonymous?;
    string status?;
    string? moderated_by_user_id?;
    string? moderation_reason?;
    int likes_count?;
    int replies_count?;
    boolean is_pinned?;
    time:Utc created_at?;
    time:Utc updated_at?;
    time:Utc? moderated_at?;
    string authorId?;
    int policyId?;
    int budget_categoryId?;
    string proposalId?;
|};

public type Vote record {|
    readonly string id;
    string vote_type;
    string? vote_reason;
    string votable_type;
    string votable_id;
    string voter_user_id;
    string? voter_role_at_time;
    boolean is_public_vote;
    string? voting_session_id;
    string? vote_metadata_json;
    time:Utc created_at;
    time:Utc? updated_at;
    string voterId;
    string proposalId;
|};

public type VoteOptionalized record {|
    string id?;
    string vote_type?;
    string? vote_reason?;
    string votable_type?;
    string votable_id?;
    string voter_user_id?;
    string? voter_role_at_time?;
    boolean is_public_vote?;
    string? voting_session_id?;
    string? vote_metadata_json?;
    time:Utc created_at?;
    time:Utc? updated_at?;
    string voterId?;
    string proposalId?;
|};

public type VoteWithRelations record {|
    *VoteOptionalized;
    UserOptionalized voter?;
    ProposalOptionalized proposal?;
|};

public type VoteTargetType typedesc<VoteWithRelations>;

public type VoteInsert Vote;

public type VoteUpdate record {|
    string vote_type?;
    string? vote_reason?;
    string votable_type?;
    string votable_id?;
    string voter_user_id?;
    string? voter_role_at_time?;
    boolean is_public_vote?;
    string? voting_session_id?;
    string? vote_metadata_json?;
    time:Utc created_at?;
    time:Utc? updated_at?;
    string voterId?;
    string proposalId?;
|};

public type Proposal record {|
    readonly string id;
    string title;
    string description;
    string proposal_type;
    string? ministry;
    string? department;
    string? affected_areas_json;
    decimal? estimated_cost;
    string? funding_source;
    string? cost_breakdown_json;
    time:Utc? proposed_start_date;
    time:Utc? proposed_end_date;
    string? implementation_plan;
    string submitted_by_user_id;
    string? supporting_organizations_json;
    int votes_for;
    int votes_against;
    int votes_abstain;
    string status;
    string? assigned_reviewer_user_id;
    string? committee_assigned;
    boolean public_voting_enabled;
    time:Utc? voting_start_date;
    time:Utc? voting_end_date;
    string? supporting_documents_json;
    string? impact_assessment;
    time:Utc created_at;
    time:Utc updated_at;
    time:Utc? last_reviewed_date;
    string submitted_byId;

|};

public type ProposalOptionalized record {|
    string id?;
    string title?;
    string description?;
    string proposal_type?;
    string? ministry?;
    string? department?;
    string? affected_areas_json?;
    decimal? estimated_cost?;
    string? funding_source?;
    string? cost_breakdown_json?;
    time:Utc? proposed_start_date?;
    time:Utc? proposed_end_date?;
    string? implementation_plan?;
    string submitted_by_user_id?;
    string? supporting_organizations_json?;
    int votes_for?;
    int votes_against?;
    int votes_abstain?;
    string status?;
    string? assigned_reviewer_user_id?;
    string? committee_assigned?;
    boolean public_voting_enabled?;
    time:Utc? voting_start_date?;
    time:Utc? voting_end_date?;
    string? supporting_documents_json?;
    string? impact_assessment?;
    time:Utc created_at?;
    time:Utc updated_at?;
    time:Utc? last_reviewed_date?;
    string submitted_byId?;
|};

public type ProposalWithRelations record {|
    *ProposalOptionalized;
    UserOptionalized submitted_by?;
    VoteOptionalized[] votes?;
    CommentOptionalized[] comments?;
|};

public type ProposalTargetType typedesc<ProposalWithRelations>;

public type ProposalInsert Proposal;

public type ProposalUpdate record {|
    string title?;
    string description?;
    string proposal_type?;
    string? ministry?;
    string? department?;
    string? affected_areas_json?;
    decimal? estimated_cost?;
    string? funding_source?;
    string? cost_breakdown_json?;
    time:Utc? proposed_start_date?;
    time:Utc? proposed_end_date?;
    string? implementation_plan?;
    string submitted_by_user_id?;
    string? supporting_organizations_json?;
    int votes_for?;
    int votes_against?;
    int votes_abstain?;
    string status?;
    string? assigned_reviewer_user_id?;
    string? committee_assigned?;
    boolean public_voting_enabled?;
    time:Utc? voting_start_date?;
    time:Utc? voting_end_date?;
    string? supporting_documents_json?;
    string? impact_assessment?;
    time:Utc created_at?;
    time:Utc updated_at?;
    time:Utc? last_reviewed_date?;
    string submitted_byId?;
|};

public type PolicyAmendment record {|
    readonly string id;
    string amendment_title;
    string amendment_description;
    string amendment_type;
    int policy_id;
    string? original_content_json;
    string? amended_content_json;
    string? justification;
    string status;
    string proposed_by_user_id;
    string? approved_by_user_id;
    time:Utc? effective_date;
    boolean is_emergency_amendment;
    time:Utc created_at;
    time:Utc updated_at;
    int policyId;
    string proposed_byId;
|};

public type PolicyAmendmentOptionalized record {|
    string id?;
    string amendment_title?;
    string amendment_description?;
    string amendment_type?;
    int policy_id?;
    string? original_content_json?;
    string? amended_content_json?;
    string? justification?;
    string status?;
    string proposed_by_user_id?;
    string? approved_by_user_id?;
    time:Utc? effective_date?;
    boolean is_emergency_amendment?;
    time:Utc created_at?;
    time:Utc updated_at?;
    int policyId?;
    string proposed_byId?;
|};

public type PolicyAmendmentWithRelations record {|
    *PolicyAmendmentOptionalized;
    PolicyOptionalized policy?;
    UserOptionalized proposed_by?;
|};

public type PolicyAmendmentTargetType typedesc<PolicyAmendmentWithRelations>;

public type PolicyAmendmentInsert PolicyAmendment;

public type PolicyAmendmentUpdate record {|
    string amendment_title?;
    string amendment_description?;
    string amendment_type?;
    int policy_id?;
    string? original_content_json?;
    string? amended_content_json?;
    string? justification?;
    string status?;
    string proposed_by_user_id?;
    string? approved_by_user_id?;
    time:Utc? effective_date?;
    boolean is_emergency_amendment?;
    time:Utc created_at?;
    time:Utc updated_at?;
    int policyId?;
    string proposed_byId?;
|};

