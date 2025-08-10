// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/jballerina.java;
import ballerina/persist;
import ballerina/sql;
import ballerinax/persist.sql as psql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

const USER = "users";
const BUDGET_CATEGORY = "budgetcategories";
const POLICY = "policies";
const BUDGET_TRANSACTION = "budgettransactions";
const COMMENT = "comments";
const VOTE = "votes";
const PROPOSAL = "proposals";
const POLICY_AMENDMENT = "policyamendments";

public isolated client class Client {
    *persist:AbstractPersistClient;

    private final postgresql:Client dbClient;

    private final map<psql:SQLClient> persistClients;

    private final record {|psql:SQLMetadata...;|} metadata = {
        [USER]: {
            entityName: "User",
            tableName: "User",
            fieldMetadata: {
                id: {columnName: "id"},
                email: {columnName: "email"},
                username: {columnName: "username"},
                full_name: {columnName: "full_name"},
                auth_id: {columnName: "auth_id"},
                role: {columnName: "role"},
                phone: {columnName: "phone"},
                address: {columnName: "address"},
                organization: {columnName: "organization"},
                ministry_affiliation: {columnName: "ministry_affiliation"},
                is_active: {columnName: "is_active"},
                email_verified: {columnName: "email_verified"},
                created_at: {columnName: "created_at"},
                updated_at: {columnName: "updated_at"},
                "categories[].id": {relation: {entityName: "categories", refField: "id"}},
                "categories[].category_name": {relation: {entityName: "categories", refField: "category_name"}},
                "categories[].description": {relation: {entityName: "categories", refField: "description"}},
                "categories[].allocated_budget": {relation: {entityName: "categories", refField: "allocated_budget"}},
                "categories[].spent_budget": {relation: {entityName: "categories", refField: "spent_budget"}},
                "categories[].reserved_budget": {relation: {entityName: "categories", refField: "reserved_budget"}},
                "categories[].fiscal_year": {relation: {entityName: "categories", refField: "fiscal_year"}},
                "categories[].ministry": {relation: {entityName: "categories", refField: "ministry"}},
                "categories[].department": {relation: {entityName: "categories", refField: "department"}},
                "categories[].status": {relation: {entityName: "categories", refField: "status"}},
                "categories[].approval_authority": {relation: {entityName: "categories", refField: "approval_authority"}},
                "categories[].budget_source": {relation: {entityName: "categories", refField: "budget_source"}},
                "categories[].tracking_code": {relation: {entityName: "categories", refField: "tracking_code"}},
                "categories[].budget_breakdown_json": {relation: {entityName: "categories", refField: "budget_breakdown_json"}},
                "categories[].created_by_user_id": {relation: {entityName: "categories", refField: "created_by_user_id"}},
                "categories[].last_modified_by_user_id": {relation: {entityName: "categories", refField: "last_modified_by_user_id"}},
                "categories[].created_at": {relation: {entityName: "categories", refField: "created_at"}},
                "categories[].updated_at": {relation: {entityName: "categories", refField: "updated_at"}},
                "categories[].approval_date": {relation: {entityName: "categories", refField: "approval_date"}},
                "categories[].created_byId": {relation: {entityName: "categories", refField: "created_byId"}},
                "authored_policies[].id": {relation: {entityName: "authored_policies", refField: "id"}},
                "authored_policies[].name": {relation: {entityName: "authored_policies", refField: "name"}},
                "authored_policies[].description": {relation: {entityName: "authored_policies", refField: "description"}},
                "authored_policies[].policy_number": {relation: {entityName: "authored_policies", refField: "policy_number"}},
                "authored_policies[].view_full_policy": {relation: {entityName: "authored_policies", refField: "view_full_policy"}},
                "authored_policies[].policy_document_json": {relation: {entityName: "authored_policies", refField: "policy_document_json"}},
                "authored_policies[].ministry": {relation: {entityName: "authored_policies", refField: "ministry"}},
                "authored_policies[].department": {relation: {entityName: "authored_policies", refField: "department"}},
                "authored_policies[].issuing_authority": {relation: {entityName: "authored_policies", refField: "issuing_authority"}},
                "authored_policies[].status": {relation: {entityName: "authored_policies", refField: "status"}},
                "authored_policies[].policy_type": {relation: {entityName: "authored_policies", refField: "policy_type"}},
                "authored_policies[].priority_level": {relation: {entityName: "authored_policies", refField: "priority_level"}},
                "authored_policies[].effective_date": {relation: {entityName: "authored_policies", refField: "effective_date"}},
                "authored_policies[].expiry_date": {relation: {entityName: "authored_policies", refField: "expiry_date"}},
                "authored_policies[].implementation_status": {relation: {entityName: "authored_policies", refField: "implementation_status"}},
                "authored_policies[].legal_reference": {relation: {entityName: "authored_policies", refField: "legal_reference"}},
                "authored_policies[].parent_legislation": {relation: {entityName: "authored_policies", refField: "parent_legislation"}},
                "authored_policies[].affected_sectors_json": {relation: {entityName: "authored_policies", refField: "affected_sectors_json"}},
                "authored_policies[].public_consultation_required": {relation: {entityName: "authored_policies", refField: "public_consultation_required"}},
                "authored_policies[].consultation_start_date": {relation: {entityName: "authored_policies", refField: "consultation_start_date"}},
                "authored_policies[].consultation_end_date": {relation: {entityName: "authored_policies", refField: "consultation_end_date"}},
                "authored_policies[].authored_by_user_id": {relation: {entityName: "authored_policies", refField: "authored_by_user_id"}},
                "authored_policies[].approved_by_user_id": {relation: {entityName: "authored_policies", refField: "approved_by_user_id"}},
                "authored_policies[].reviewed_by_user_id": {relation: {entityName: "authored_policies", refField: "reviewed_by_user_id"}},
                "authored_policies[].tags_json": {relation: {entityName: "authored_policies", refField: "tags_json"}},
                "authored_policies[].metadata_json": {relation: {entityName: "authored_policies", refField: "metadata_json"}},
                "authored_policies[].created_at": {relation: {entityName: "authored_policies", refField: "created_at"}},
                "authored_policies[].updated_at": {relation: {entityName: "authored_policies", refField: "updated_at"}},
                "authored_policies[].last_reviewed_date": {relation: {entityName: "authored_policies", refField: "last_reviewed_date"}},
                "authored_policies[].authored_byId": {relation: {entityName: "authored_policies", refField: "authored_byId"}},
                "proposals[].id": {relation: {entityName: "proposals", refField: "id"}},
                "proposals[].title": {relation: {entityName: "proposals", refField: "title"}},
                "proposals[].description": {relation: {entityName: "proposals", refField: "description"}},
                "proposals[].proposal_type": {relation: {entityName: "proposals", refField: "proposal_type"}},
                "proposals[].ministry": {relation: {entityName: "proposals", refField: "ministry"}},
                "proposals[].department": {relation: {entityName: "proposals", refField: "department"}},
                "proposals[].affected_areas_json": {relation: {entityName: "proposals", refField: "affected_areas_json"}},
                "proposals[].estimated_cost": {relation: {entityName: "proposals", refField: "estimated_cost"}},
                "proposals[].funding_source": {relation: {entityName: "proposals", refField: "funding_source"}},
                "proposals[].cost_breakdown_json": {relation: {entityName: "proposals", refField: "cost_breakdown_json"}},
                "proposals[].proposed_start_date": {relation: {entityName: "proposals", refField: "proposed_start_date"}},
                "proposals[].proposed_end_date": {relation: {entityName: "proposals", refField: "proposed_end_date"}},
                "proposals[].implementation_plan": {relation: {entityName: "proposals", refField: "implementation_plan"}},
                "proposals[].submitted_by_user_id": {relation: {entityName: "proposals", refField: "submitted_by_user_id"}},
                "proposals[].supporting_organizations_json": {relation: {entityName: "proposals", refField: "supporting_organizations_json"}},
                "proposals[].votes_for": {relation: {entityName: "proposals", refField: "votes_for"}},
                "proposals[].votes_against": {relation: {entityName: "proposals", refField: "votes_against"}},
                "proposals[].votes_abstain": {relation: {entityName: "proposals", refField: "votes_abstain"}},
                "proposals[].status": {relation: {entityName: "proposals", refField: "status"}},
                "proposals[].assigned_reviewer_user_id": {relation: {entityName: "proposals", refField: "assigned_reviewer_user_id"}},
                "proposals[].committee_assigned": {relation: {entityName: "proposals", refField: "committee_assigned"}},
                "proposals[].public_voting_enabled": {relation: {entityName: "proposals", refField: "public_voting_enabled"}},
                "proposals[].voting_start_date": {relation: {entityName: "proposals", refField: "voting_start_date"}},
                "proposals[].voting_end_date": {relation: {entityName: "proposals", refField: "voting_end_date"}},
                "proposals[].supporting_documents_json": {relation: {entityName: "proposals", refField: "supporting_documents_json"}},
                "proposals[].impact_assessment": {relation: {entityName: "proposals", refField: "impact_assessment"}},
                "proposals[].created_at": {relation: {entityName: "proposals", refField: "created_at"}},
                "proposals[].updated_at": {relation: {entityName: "proposals", refField: "updated_at"}},
                "proposals[].last_reviewed_date": {relation: {entityName: "proposals", refField: "last_reviewed_date"}},
                "proposals[].submitted_byId": {relation: {entityName: "proposals", refField: "submitted_byId"}},
                "comments[].id": {relation: {entityName: "comments", refField: "id"}},
                "comments[].content": {relation: {entityName: "comments", refField: "content"}},
                "comments[].comment_type": {relation: {entityName: "comments", refField: "comment_type"}},
                "comments[].commentable_type": {relation: {entityName: "comments", refField: "commentable_type"}},
                "comments[].commentable_id": {relation: {entityName: "comments", refField: "commentable_id"}},
                "comments[].parent_comment_id": {relation: {entityName: "comments", refField: "parent_comment_id"}},
                "comments[].thread_level": {relation: {entityName: "comments", refField: "thread_level"}},
                "comments[].author_user_id": {relation: {entityName: "comments", refField: "author_user_id"}},
                "comments[].is_anonymous": {relation: {entityName: "comments", refField: "is_anonymous"}},
                "comments[].status": {relation: {entityName: "comments", refField: "status"}},
                "comments[].moderated_by_user_id": {relation: {entityName: "comments", refField: "moderated_by_user_id"}},
                "comments[].moderation_reason": {relation: {entityName: "comments", refField: "moderation_reason"}},
                "comments[].likes_count": {relation: {entityName: "comments", refField: "likes_count"}},
                "comments[].replies_count": {relation: {entityName: "comments", refField: "replies_count"}},
                "comments[].is_pinned": {relation: {entityName: "comments", refField: "is_pinned"}},
                "comments[].created_at": {relation: {entityName: "comments", refField: "created_at"}},
                "comments[].updated_at": {relation: {entityName: "comments", refField: "updated_at"}},
                "comments[].moderated_at": {relation: {entityName: "comments", refField: "moderated_at"}},
                "comments[].authorId": {relation: {entityName: "comments", refField: "authorId"}},
                "comments[].policyId": {relation: {entityName: "comments", refField: "policyId"}},
                "comments[].budget_categoryId": {relation: {entityName: "comments", refField: "budget_categoryId"}},
                "comments[].proposalId": {relation: {entityName: "comments", refField: "proposalId"}},
                "votes[].id": {relation: {entityName: "votes", refField: "id"}},
                "votes[].vote_type": {relation: {entityName: "votes", refField: "vote_type"}},
                "votes[].vote_reason": {relation: {entityName: "votes", refField: "vote_reason"}},
                "votes[].votable_type": {relation: {entityName: "votes", refField: "votable_type"}},
                "votes[].votable_id": {relation: {entityName: "votes", refField: "votable_id"}},
                "votes[].voter_user_id": {relation: {entityName: "votes", refField: "voter_user_id"}},
                "votes[].voter_role_at_time": {relation: {entityName: "votes", refField: "voter_role_at_time"}},
                "votes[].is_public_vote": {relation: {entityName: "votes", refField: "is_public_vote"}},
                "votes[].voting_session_id": {relation: {entityName: "votes", refField: "voting_session_id"}},
                "votes[].vote_metadata_json": {relation: {entityName: "votes", refField: "vote_metadata_json"}},
                "votes[].created_at": {relation: {entityName: "votes", refField: "created_at"}},
                "votes[].updated_at": {relation: {entityName: "votes", refField: "updated_at"}},
                "votes[].voterId": {relation: {entityName: "votes", refField: "voterId"}},
                "votes[].proposalId": {relation: {entityName: "votes", refField: "proposalId"}},
                "proposed_amendments[].id": {relation: {entityName: "proposed_amendments", refField: "id"}},
                "proposed_amendments[].amendment_title": {relation: {entityName: "proposed_amendments", refField: "amendment_title"}},
                "proposed_amendments[].amendment_description": {relation: {entityName: "proposed_amendments", refField: "amendment_description"}},
                "proposed_amendments[].amendment_type": {relation: {entityName: "proposed_amendments", refField: "amendment_type"}},
                "proposed_amendments[].policy_id": {relation: {entityName: "proposed_amendments", refField: "policy_id"}},
                "proposed_amendments[].original_content_json": {relation: {entityName: "proposed_amendments", refField: "original_content_json"}},
                "proposed_amendments[].amended_content_json": {relation: {entityName: "proposed_amendments", refField: "amended_content_json"}},
                "proposed_amendments[].justification": {relation: {entityName: "proposed_amendments", refField: "justification"}},
                "proposed_amendments[].status": {relation: {entityName: "proposed_amendments", refField: "status"}},
                "proposed_amendments[].proposed_by_user_id": {relation: {entityName: "proposed_amendments", refField: "proposed_by_user_id"}},
                "proposed_amendments[].approved_by_user_id": {relation: {entityName: "proposed_amendments", refField: "approved_by_user_id"}},
                "proposed_amendments[].effective_date": {relation: {entityName: "proposed_amendments", refField: "effective_date"}},
                "proposed_amendments[].is_emergency_amendment": {relation: {entityName: "proposed_amendments", refField: "is_emergency_amendment"}},
                "proposed_amendments[].created_at": {relation: {entityName: "proposed_amendments", refField: "created_at"}},
                "proposed_amendments[].updated_at": {relation: {entityName: "proposed_amendments", refField: "updated_at"}},
                "proposed_amendments[].policyId": {relation: {entityName: "proposed_amendments", refField: "policyId"}},
                "proposed_amendments[].proposed_byId": {relation: {entityName: "proposed_amendments", refField: "proposed_byId"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                categories: {entity: BudgetCategory, fieldName: "categories", refTable: "BudgetCategory", refColumns: ["created_byId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                authored_policies: {entity: Policy, fieldName: "authored_policies", refTable: "Policy", refColumns: ["authored_byId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                proposals: {entity: Proposal, fieldName: "proposals", refTable: "Proposal", refColumns: ["submitted_byId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                comments: {entity: Comment, fieldName: "comments", refTable: "Comment", refColumns: ["authorId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                votes: {entity: Vote, fieldName: "votes", refTable: "Vote", refColumns: ["voterId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                proposed_amendments: {entity: PolicyAmendment, fieldName: "proposed_amendments", refTable: "PolicyAmendment", refColumns: ["proposed_byId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}
            }
        },
        [BUDGET_CATEGORY]: {
            entityName: "BudgetCategory",
            tableName: "BudgetCategory",
            fieldMetadata: {
                id: {columnName: "id"},
                category_name: {columnName: "category_name"},
                description: {columnName: "description"},
                allocated_budget: {columnName: "allocated_budget"},
                spent_budget: {columnName: "spent_budget"},
                reserved_budget: {columnName: "reserved_budget"},
                fiscal_year: {columnName: "fiscal_year"},
                ministry: {columnName: "ministry"},
                department: {columnName: "department"},
                status: {columnName: "status"},
                approval_authority: {columnName: "approval_authority"},
                budget_source: {columnName: "budget_source"},
                tracking_code: {columnName: "tracking_code"},
                budget_breakdown_json: {columnName: "budget_breakdown_json"},
                created_by_user_id: {columnName: "created_by_user_id"},
                last_modified_by_user_id: {columnName: "last_modified_by_user_id"},
                created_at: {columnName: "created_at"},
                updated_at: {columnName: "updated_at"},
                approval_date: {columnName: "approval_date"},
                created_byId: {columnName: "created_byId"},
                "created_by.id": {relation: {entityName: "created_by", refField: "id"}},
                "created_by.email": {relation: {entityName: "created_by", refField: "email"}},
                "created_by.username": {relation: {entityName: "created_by", refField: "username"}},
                "created_by.full_name": {relation: {entityName: "created_by", refField: "full_name"}},
                "created_by.auth_id": {relation: {entityName: "created_by", refField: "auth_id"}},
                "created_by.role": {relation: {entityName: "created_by", refField: "role"}},
                "created_by.phone": {relation: {entityName: "created_by", refField: "phone"}},
                "created_by.address": {relation: {entityName: "created_by", refField: "address"}},
                "created_by.organization": {relation: {entityName: "created_by", refField: "organization"}},
                "created_by.ministry_affiliation": {relation: {entityName: "created_by", refField: "ministry_affiliation"}},
                "created_by.is_active": {relation: {entityName: "created_by", refField: "is_active"}},
                "created_by.email_verified": {relation: {entityName: "created_by", refField: "email_verified"}},
                "created_by.created_at": {relation: {entityName: "created_by", refField: "created_at"}},
                "created_by.updated_at": {relation: {entityName: "created_by", refField: "updated_at"}},
                "transactions[].id": {relation: {entityName: "transactions", refField: "id"}},
                "transactions[].transaction_type": {relation: {entityName: "transactions", refField: "transaction_type"}},
                "transactions[].amount": {relation: {entityName: "transactions", refField: "amount"}},
                "transactions[].description": {relation: {entityName: "transactions", refField: "description"}},
                "transactions[].budget_category_id": {relation: {entityName: "transactions", refField: "budget_category_id"}},
                "transactions[].transaction_reference": {relation: {entityName: "transactions", refField: "transaction_reference"}},
                "transactions[].invoice_number": {relation: {entityName: "transactions", refField: "invoice_number"}},
                "transactions[].vendor_information": {relation: {entityName: "transactions", refField: "vendor_information"}},
                "transactions[].status": {relation: {entityName: "transactions", refField: "status"}},
                "transactions[].approved_by_user_id": {relation: {entityName: "transactions", refField: "approved_by_user_id"}},
                "transactions[].executed_by_user_id": {relation: {entityName: "transactions", refField: "executed_by_user_id"}},
                "transactions[].accounting_code": {relation: {entityName: "transactions", refField: "accounting_code"}},
                "transactions[].cost_center": {relation: {entityName: "transactions", refField: "cost_center"}},
                "transactions[].line_items_json": {relation: {entityName: "transactions", refField: "line_items_json"}},
                "transactions[].compliance_status": {relation: {entityName: "transactions", refField: "compliance_status"}},
                "transactions[].audit_notes": {relation: {entityName: "transactions", refField: "audit_notes"}},
                "transactions[].requires_additional_approval": {relation: {entityName: "transactions", refField: "requires_additional_approval"}},
                "transactions[].supporting_documents_json": {relation: {entityName: "transactions", refField: "supporting_documents_json"}},
                "transactions[].attachment_urls": {relation: {entityName: "transactions", refField: "attachment_urls"}},
                "transactions[].created_at": {relation: {entityName: "transactions", refField: "created_at"}},
                "transactions[].updated_at": {relation: {entityName: "transactions", refField: "updated_at"}},
                "transactions[].transaction_date": {relation: {entityName: "transactions", refField: "transaction_date"}},
                "transactions[].approval_date": {relation: {entityName: "transactions", refField: "approval_date"}},
                "transactions[].execution_date": {relation: {entityName: "transactions", refField: "execution_date"}},
                "transactions[].budget_categoryId": {relation: {entityName: "transactions", refField: "budget_categoryId"}},
                "comments[].id": {relation: {entityName: "comments", refField: "id"}},
                "comments[].content": {relation: {entityName: "comments", refField: "content"}},
                "comments[].comment_type": {relation: {entityName: "comments", refField: "comment_type"}},
                "comments[].commentable_type": {relation: {entityName: "comments", refField: "commentable_type"}},
                "comments[].commentable_id": {relation: {entityName: "comments", refField: "commentable_id"}},
                "comments[].parent_comment_id": {relation: {entityName: "comments", refField: "parent_comment_id"}},
                "comments[].thread_level": {relation: {entityName: "comments", refField: "thread_level"}},
                "comments[].author_user_id": {relation: {entityName: "comments", refField: "author_user_id"}},
                "comments[].is_anonymous": {relation: {entityName: "comments", refField: "is_anonymous"}},
                "comments[].status": {relation: {entityName: "comments", refField: "status"}},
                "comments[].moderated_by_user_id": {relation: {entityName: "comments", refField: "moderated_by_user_id"}},
                "comments[].moderation_reason": {relation: {entityName: "comments", refField: "moderation_reason"}},
                "comments[].likes_count": {relation: {entityName: "comments", refField: "likes_count"}},
                "comments[].replies_count": {relation: {entityName: "comments", refField: "replies_count"}},
                "comments[].is_pinned": {relation: {entityName: "comments", refField: "is_pinned"}},
                "comments[].created_at": {relation: {entityName: "comments", refField: "created_at"}},
                "comments[].updated_at": {relation: {entityName: "comments", refField: "updated_at"}},
                "comments[].moderated_at": {relation: {entityName: "comments", refField: "moderated_at"}},
                "comments[].authorId": {relation: {entityName: "comments", refField: "authorId"}},
                "comments[].policyId": {relation: {entityName: "comments", refField: "policyId"}},
                "comments[].budget_categoryId": {relation: {entityName: "comments", refField: "budget_categoryId"}},
                "comments[].proposalId": {relation: {entityName: "comments", refField: "proposalId"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                created_by: {entity: User, fieldName: "created_by", refTable: "User", refColumns: ["id"], joinColumns: ["created_byId"], 'type: psql:ONE_TO_MANY},
                transactions: {entity: BudgetTransaction, fieldName: "transactions", refTable: "BudgetTransaction", refColumns: ["budget_categoryId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                comments: {entity: Comment, fieldName: "comments", refTable: "Comment", refColumns: ["budget_categoryId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}
            }
        },
        [POLICY]: {
            entityName: "Policy",
            tableName: "Policy",
            fieldMetadata: {
                id: {columnName: "id"},
                name: {columnName: "name"},
                description: {columnName: "description"},
                policy_number: {columnName: "policy_number"},
                view_full_policy: {columnName: "view_full_policy"},
                policy_document_json: {columnName: "policy_document_json"},
                ministry: {columnName: "ministry"},
                department: {columnName: "department"},
                issuing_authority: {columnName: "issuing_authority"},
                status: {columnName: "status"},
                policy_type: {columnName: "policy_type"},
                priority_level: {columnName: "priority_level"},
                effective_date: {columnName: "effective_date"},
                expiry_date: {columnName: "expiry_date"},
                implementation_status: {columnName: "implementation_status"},
                legal_reference: {columnName: "legal_reference"},
                parent_legislation: {columnName: "parent_legislation"},
                affected_sectors_json: {columnName: "affected_sectors_json"},
                public_consultation_required: {columnName: "public_consultation_required"},
                consultation_start_date: {columnName: "consultation_start_date"},
                consultation_end_date: {columnName: "consultation_end_date"},
                authored_by_user_id: {columnName: "authored_by_user_id"},
                approved_by_user_id: {columnName: "approved_by_user_id"},
                reviewed_by_user_id: {columnName: "reviewed_by_user_id"},
                tags_json: {columnName: "tags_json"},
                metadata_json: {columnName: "metadata_json"},
                created_at: {columnName: "created_at"},
                updated_at: {columnName: "updated_at"},
                last_reviewed_date: {columnName: "last_reviewed_date"},
                authored_byId: {columnName: "authored_byId"},
                "authored_by.id": {relation: {entityName: "authored_by", refField: "id"}},
                "authored_by.email": {relation: {entityName: "authored_by", refField: "email"}},
                "authored_by.username": {relation: {entityName: "authored_by", refField: "username"}},
                "authored_by.full_name": {relation: {entityName: "authored_by", refField: "full_name"}},
                "authored_by.auth_id": {relation: {entityName: "authored_by", refField: "auth_id"}},
                "authored_by.role": {relation: {entityName: "authored_by", refField: "role"}},
                "authored_by.phone": {relation: {entityName: "authored_by", refField: "phone"}},
                "authored_by.address": {relation: {entityName: "authored_by", refField: "address"}},
                "authored_by.organization": {relation: {entityName: "authored_by", refField: "organization"}},
                "authored_by.ministry_affiliation": {relation: {entityName: "authored_by", refField: "ministry_affiliation"}},
                "authored_by.is_active": {relation: {entityName: "authored_by", refField: "is_active"}},
                "authored_by.email_verified": {relation: {entityName: "authored_by", refField: "email_verified"}},
                "authored_by.created_at": {relation: {entityName: "authored_by", refField: "created_at"}},
                "authored_by.updated_at": {relation: {entityName: "authored_by", refField: "updated_at"}},
                "comments[].id": {relation: {entityName: "comments", refField: "id"}},
                "comments[].content": {relation: {entityName: "comments", refField: "content"}},
                "comments[].comment_type": {relation: {entityName: "comments", refField: "comment_type"}},
                "comments[].commentable_type": {relation: {entityName: "comments", refField: "commentable_type"}},
                "comments[].commentable_id": {relation: {entityName: "comments", refField: "commentable_id"}},
                "comments[].parent_comment_id": {relation: {entityName: "comments", refField: "parent_comment_id"}},
                "comments[].thread_level": {relation: {entityName: "comments", refField: "thread_level"}},
                "comments[].author_user_id": {relation: {entityName: "comments", refField: "author_user_id"}},
                "comments[].is_anonymous": {relation: {entityName: "comments", refField: "is_anonymous"}},
                "comments[].status": {relation: {entityName: "comments", refField: "status"}},
                "comments[].moderated_by_user_id": {relation: {entityName: "comments", refField: "moderated_by_user_id"}},
                "comments[].moderation_reason": {relation: {entityName: "comments", refField: "moderation_reason"}},
                "comments[].likes_count": {relation: {entityName: "comments", refField: "likes_count"}},
                "comments[].replies_count": {relation: {entityName: "comments", refField: "replies_count"}},
                "comments[].is_pinned": {relation: {entityName: "comments", refField: "is_pinned"}},
                "comments[].created_at": {relation: {entityName: "comments", refField: "created_at"}},
                "comments[].updated_at": {relation: {entityName: "comments", refField: "updated_at"}},
                "comments[].moderated_at": {relation: {entityName: "comments", refField: "moderated_at"}},
                "comments[].authorId": {relation: {entityName: "comments", refField: "authorId"}},
                "comments[].policyId": {relation: {entityName: "comments", refField: "policyId"}},
                "comments[].budget_categoryId": {relation: {entityName: "comments", refField: "budget_categoryId"}},
                "comments[].proposalId": {relation: {entityName: "comments", refField: "proposalId"}},
                "amendments[].id": {relation: {entityName: "amendments", refField: "id"}},
                "amendments[].amendment_title": {relation: {entityName: "amendments", refField: "amendment_title"}},
                "amendments[].amendment_description": {relation: {entityName: "amendments", refField: "amendment_description"}},
                "amendments[].amendment_type": {relation: {entityName: "amendments", refField: "amendment_type"}},
                "amendments[].policy_id": {relation: {entityName: "amendments", refField: "policy_id"}},
                "amendments[].original_content_json": {relation: {entityName: "amendments", refField: "original_content_json"}},
                "amendments[].amended_content_json": {relation: {entityName: "amendments", refField: "amended_content_json"}},
                "amendments[].justification": {relation: {entityName: "amendments", refField: "justification"}},
                "amendments[].status": {relation: {entityName: "amendments", refField: "status"}},
                "amendments[].proposed_by_user_id": {relation: {entityName: "amendments", refField: "proposed_by_user_id"}},
                "amendments[].approved_by_user_id": {relation: {entityName: "amendments", refField: "approved_by_user_id"}},
                "amendments[].effective_date": {relation: {entityName: "amendments", refField: "effective_date"}},
                "amendments[].is_emergency_amendment": {relation: {entityName: "amendments", refField: "is_emergency_amendment"}},
                "amendments[].created_at": {relation: {entityName: "amendments", refField: "created_at"}},
                "amendments[].updated_at": {relation: {entityName: "amendments", refField: "updated_at"}},
                "amendments[].policyId": {relation: {entityName: "amendments", refField: "policyId"}},
                "amendments[].proposed_byId": {relation: {entityName: "amendments", refField: "proposed_byId"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                authored_by: {entity: User, fieldName: "authored_by", refTable: "User", refColumns: ["id"], joinColumns: ["authored_byId"], 'type: psql:ONE_TO_MANY},
                comments: {entity: Comment, fieldName: "comments", refTable: "Comment", refColumns: ["policyId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                amendments: {entity: PolicyAmendment, fieldName: "amendments", refTable: "PolicyAmendment", refColumns: ["policyId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}
            }
        },
        [BUDGET_TRANSACTION]: {
            entityName: "BudgetTransaction",
            tableName: "BudgetTransaction",
            fieldMetadata: {
                id: {columnName: "id"},
                transaction_type: {columnName: "transaction_type"},
                amount: {columnName: "amount"},
                description: {columnName: "description"},
                budget_category_id: {columnName: "budget_category_id"},
                transaction_reference: {columnName: "transaction_reference"},
                invoice_number: {columnName: "invoice_number"},
                vendor_information: {columnName: "vendor_information"},
                status: {columnName: "status"},
                approved_by_user_id: {columnName: "approved_by_user_id"},
                executed_by_user_id: {columnName: "executed_by_user_id"},
                accounting_code: {columnName: "accounting_code"},
                cost_center: {columnName: "cost_center"},
                line_items_json: {columnName: "line_items_json"},
                compliance_status: {columnName: "compliance_status"},
                audit_notes: {columnName: "audit_notes"},
                requires_additional_approval: {columnName: "requires_additional_approval"},
                supporting_documents_json: {columnName: "supporting_documents_json"},
                attachment_urls: {columnName: "attachment_urls"},
                created_at: {columnName: "created_at"},
                updated_at: {columnName: "updated_at"},
                transaction_date: {columnName: "transaction_date"},
                approval_date: {columnName: "approval_date"},
                execution_date: {columnName: "execution_date"},
                budget_categoryId: {columnName: "budget_categoryId"},
                "budget_category.id": {relation: {entityName: "budget_category", refField: "id"}},
                "budget_category.category_name": {relation: {entityName: "budget_category", refField: "category_name"}},
                "budget_category.description": {relation: {entityName: "budget_category", refField: "description"}},
                "budget_category.allocated_budget": {relation: {entityName: "budget_category", refField: "allocated_budget"}},
                "budget_category.spent_budget": {relation: {entityName: "budget_category", refField: "spent_budget"}},
                "budget_category.reserved_budget": {relation: {entityName: "budget_category", refField: "reserved_budget"}},
                "budget_category.fiscal_year": {relation: {entityName: "budget_category", refField: "fiscal_year"}},
                "budget_category.ministry": {relation: {entityName: "budget_category", refField: "ministry"}},
                "budget_category.department": {relation: {entityName: "budget_category", refField: "department"}},
                "budget_category.status": {relation: {entityName: "budget_category", refField: "status"}},
                "budget_category.approval_authority": {relation: {entityName: "budget_category", refField: "approval_authority"}},
                "budget_category.budget_source": {relation: {entityName: "budget_category", refField: "budget_source"}},
                "budget_category.tracking_code": {relation: {entityName: "budget_category", refField: "tracking_code"}},
                "budget_category.budget_breakdown_json": {relation: {entityName: "budget_category", refField: "budget_breakdown_json"}},
                "budget_category.created_by_user_id": {relation: {entityName: "budget_category", refField: "created_by_user_id"}},
                "budget_category.last_modified_by_user_id": {relation: {entityName: "budget_category", refField: "last_modified_by_user_id"}},
                "budget_category.created_at": {relation: {entityName: "budget_category", refField: "created_at"}},
                "budget_category.updated_at": {relation: {entityName: "budget_category", refField: "updated_at"}},
                "budget_category.approval_date": {relation: {entityName: "budget_category", refField: "approval_date"}},
                "budget_category.created_byId": {relation: {entityName: "budget_category", refField: "created_byId"}}
            },
            keyFields: ["id"],
            joinMetadata: {budget_category: {entity: BudgetCategory, fieldName: "budget_category", refTable: "BudgetCategory", refColumns: ["id"], joinColumns: ["budget_categoryId"], 'type: psql:ONE_TO_MANY}}
        },
        [COMMENT]: {
            entityName: "Comment",
            tableName: "Comment",
            fieldMetadata: {
                id: {columnName: "id"},
                content: {columnName: "content"},
                comment_type: {columnName: "comment_type"},
                commentable_type: {columnName: "commentable_type"},
                commentable_id: {columnName: "commentable_id"},
                parent_comment_id: {columnName: "parent_comment_id"},
                thread_level: {columnName: "thread_level"},
                author_user_id: {columnName: "author_user_id"},
                is_anonymous: {columnName: "is_anonymous"},
                status: {columnName: "status"},
                moderated_by_user_id: {columnName: "moderated_by_user_id"},
                moderation_reason: {columnName: "moderation_reason"},
                likes_count: {columnName: "likes_count"},
                replies_count: {columnName: "replies_count"},
                is_pinned: {columnName: "is_pinned"},
                created_at: {columnName: "created_at"},
                updated_at: {columnName: "updated_at"},
                moderated_at: {columnName: "moderated_at"},
                authorId: {columnName: "authorId"},
                policyId: {columnName: "policyId"},
                budget_categoryId: {columnName: "budget_categoryId"},
                proposalId: {columnName: "proposalId"},
                "author.id": {relation: {entityName: "author", refField: "id"}},
                "author.email": {relation: {entityName: "author", refField: "email"}},
                "author.username": {relation: {entityName: "author", refField: "username"}},
                "author.full_name": {relation: {entityName: "author", refField: "full_name"}},
                "author.auth_id": {relation: {entityName: "author", refField: "auth_id"}},
                "author.role": {relation: {entityName: "author", refField: "role"}},
                "author.phone": {relation: {entityName: "author", refField: "phone"}},
                "author.address": {relation: {entityName: "author", refField: "address"}},
                "author.organization": {relation: {entityName: "author", refField: "organization"}},
                "author.ministry_affiliation": {relation: {entityName: "author", refField: "ministry_affiliation"}},
                "author.is_active": {relation: {entityName: "author", refField: "is_active"}},
                "author.email_verified": {relation: {entityName: "author", refField: "email_verified"}},
                "author.created_at": {relation: {entityName: "author", refField: "created_at"}},
                "author.updated_at": {relation: {entityName: "author", refField: "updated_at"}},
                "policy.id": {relation: {entityName: "policy", refField: "id"}},
                "policy.name": {relation: {entityName: "policy", refField: "name"}},
                "policy.description": {relation: {entityName: "policy", refField: "description"}},
                "policy.policy_number": {relation: {entityName: "policy", refField: "policy_number"}},
                "policy.view_full_policy": {relation: {entityName: "policy", refField: "view_full_policy"}},
                "policy.policy_document_json": {relation: {entityName: "policy", refField: "policy_document_json"}},
                "policy.ministry": {relation: {entityName: "policy", refField: "ministry"}},
                "policy.department": {relation: {entityName: "policy", refField: "department"}},
                "policy.issuing_authority": {relation: {entityName: "policy", refField: "issuing_authority"}},
                "policy.status": {relation: {entityName: "policy", refField: "status"}},
                "policy.policy_type": {relation: {entityName: "policy", refField: "policy_type"}},
                "policy.priority_level": {relation: {entityName: "policy", refField: "priority_level"}},
                "policy.effective_date": {relation: {entityName: "policy", refField: "effective_date"}},
                "policy.expiry_date": {relation: {entityName: "policy", refField: "expiry_date"}},
                "policy.implementation_status": {relation: {entityName: "policy", refField: "implementation_status"}},
                "policy.legal_reference": {relation: {entityName: "policy", refField: "legal_reference"}},
                "policy.parent_legislation": {relation: {entityName: "policy", refField: "parent_legislation"}},
                "policy.affected_sectors_json": {relation: {entityName: "policy", refField: "affected_sectors_json"}},
                "policy.public_consultation_required": {relation: {entityName: "policy", refField: "public_consultation_required"}},
                "policy.consultation_start_date": {relation: {entityName: "policy", refField: "consultation_start_date"}},
                "policy.consultation_end_date": {relation: {entityName: "policy", refField: "consultation_end_date"}},
                "policy.authored_by_user_id": {relation: {entityName: "policy", refField: "authored_by_user_id"}},
                "policy.approved_by_user_id": {relation: {entityName: "policy", refField: "approved_by_user_id"}},
                "policy.reviewed_by_user_id": {relation: {entityName: "policy", refField: "reviewed_by_user_id"}},
                "policy.tags_json": {relation: {entityName: "policy", refField: "tags_json"}},
                "policy.metadata_json": {relation: {entityName: "policy", refField: "metadata_json"}},
                "policy.created_at": {relation: {entityName: "policy", refField: "created_at"}},
                "policy.updated_at": {relation: {entityName: "policy", refField: "updated_at"}},
                "policy.last_reviewed_date": {relation: {entityName: "policy", refField: "last_reviewed_date"}},
                "policy.authored_byId": {relation: {entityName: "policy", refField: "authored_byId"}},
                "budget_category.id": {relation: {entityName: "budget_category", refField: "id"}},
                "budget_category.category_name": {relation: {entityName: "budget_category", refField: "category_name"}},
                "budget_category.description": {relation: {entityName: "budget_category", refField: "description"}},
                "budget_category.allocated_budget": {relation: {entityName: "budget_category", refField: "allocated_budget"}},
                "budget_category.spent_budget": {relation: {entityName: "budget_category", refField: "spent_budget"}},
                "budget_category.reserved_budget": {relation: {entityName: "budget_category", refField: "reserved_budget"}},
                "budget_category.fiscal_year": {relation: {entityName: "budget_category", refField: "fiscal_year"}},
                "budget_category.ministry": {relation: {entityName: "budget_category", refField: "ministry"}},
                "budget_category.department": {relation: {entityName: "budget_category", refField: "department"}},
                "budget_category.status": {relation: {entityName: "budget_category", refField: "status"}},
                "budget_category.approval_authority": {relation: {entityName: "budget_category", refField: "approval_authority"}},
                "budget_category.budget_source": {relation: {entityName: "budget_category", refField: "budget_source"}},
                "budget_category.tracking_code": {relation: {entityName: "budget_category", refField: "tracking_code"}},
                "budget_category.budget_breakdown_json": {relation: {entityName: "budget_category", refField: "budget_breakdown_json"}},
                "budget_category.created_by_user_id": {relation: {entityName: "budget_category", refField: "created_by_user_id"}},
                "budget_category.last_modified_by_user_id": {relation: {entityName: "budget_category", refField: "last_modified_by_user_id"}},
                "budget_category.created_at": {relation: {entityName: "budget_category", refField: "created_at"}},
                "budget_category.updated_at": {relation: {entityName: "budget_category", refField: "updated_at"}},
                "budget_category.approval_date": {relation: {entityName: "budget_category", refField: "approval_date"}},
                "budget_category.created_byId": {relation: {entityName: "budget_category", refField: "created_byId"}},
                "proposal.id": {relation: {entityName: "proposal", refField: "id"}},
                "proposal.title": {relation: {entityName: "proposal", refField: "title"}},
                "proposal.description": {relation: {entityName: "proposal", refField: "description"}},
                "proposal.proposal_type": {relation: {entityName: "proposal", refField: "proposal_type"}},
                "proposal.ministry": {relation: {entityName: "proposal", refField: "ministry"}},
                "proposal.department": {relation: {entityName: "proposal", refField: "department"}},
                "proposal.affected_areas_json": {relation: {entityName: "proposal", refField: "affected_areas_json"}},
                "proposal.estimated_cost": {relation: {entityName: "proposal", refField: "estimated_cost"}},
                "proposal.funding_source": {relation: {entityName: "proposal", refField: "funding_source"}},
                "proposal.cost_breakdown_json": {relation: {entityName: "proposal", refField: "cost_breakdown_json"}},
                "proposal.proposed_start_date": {relation: {entityName: "proposal", refField: "proposed_start_date"}},
                "proposal.proposed_end_date": {relation: {entityName: "proposal", refField: "proposed_end_date"}},
                "proposal.implementation_plan": {relation: {entityName: "proposal", refField: "implementation_plan"}},
                "proposal.submitted_by_user_id": {relation: {entityName: "proposal", refField: "submitted_by_user_id"}},
                "proposal.supporting_organizations_json": {relation: {entityName: "proposal", refField: "supporting_organizations_json"}},
                "proposal.votes_for": {relation: {entityName: "proposal", refField: "votes_for"}},
                "proposal.votes_against": {relation: {entityName: "proposal", refField: "votes_against"}},
                "proposal.votes_abstain": {relation: {entityName: "proposal", refField: "votes_abstain"}},
                "proposal.status": {relation: {entityName: "proposal", refField: "status"}},
                "proposal.assigned_reviewer_user_id": {relation: {entityName: "proposal", refField: "assigned_reviewer_user_id"}},
                "proposal.committee_assigned": {relation: {entityName: "proposal", refField: "committee_assigned"}},
                "proposal.public_voting_enabled": {relation: {entityName: "proposal", refField: "public_voting_enabled"}},
                "proposal.voting_start_date": {relation: {entityName: "proposal", refField: "voting_start_date"}},
                "proposal.voting_end_date": {relation: {entityName: "proposal", refField: "voting_end_date"}},
                "proposal.supporting_documents_json": {relation: {entityName: "proposal", refField: "supporting_documents_json"}},
                "proposal.impact_assessment": {relation: {entityName: "proposal", refField: "impact_assessment"}},
                "proposal.created_at": {relation: {entityName: "proposal", refField: "created_at"}},
                "proposal.updated_at": {relation: {entityName: "proposal", refField: "updated_at"}},
                "proposal.last_reviewed_date": {relation: {entityName: "proposal", refField: "last_reviewed_date"}},
                "proposal.submitted_byId": {relation: {entityName: "proposal", refField: "submitted_byId"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                author: {entity: User, fieldName: "author", refTable: "User", refColumns: ["id"], joinColumns: ["authorId"], 'type: psql:ONE_TO_MANY},
                policy: {entity: Policy, fieldName: "policy", refTable: "Policy", refColumns: ["id"], joinColumns: ["policyId"], 'type: psql:ONE_TO_MANY},
                budget_category: {entity: BudgetCategory, fieldName: "budget_category", refTable: "BudgetCategory", refColumns: ["id"], joinColumns: ["budget_categoryId"], 'type: psql:ONE_TO_MANY},
                proposal: {entity: Proposal, fieldName: "proposal", refTable: "Proposal", refColumns: ["id"], joinColumns: ["proposalId"], 'type: psql:ONE_TO_MANY}
            }
        },
        [VOTE]: {
            entityName: "Vote",
            tableName: "Vote",
            fieldMetadata: {
                id: {columnName: "id"},
                vote_type: {columnName: "vote_type"},
                vote_reason: {columnName: "vote_reason"},
                votable_type: {columnName: "votable_type"},
                votable_id: {columnName: "votable_id"},
                voter_user_id: {columnName: "voter_user_id"},
                voter_role_at_time: {columnName: "voter_role_at_time"},
                is_public_vote: {columnName: "is_public_vote"},
                voting_session_id: {columnName: "voting_session_id"},
                vote_metadata_json: {columnName: "vote_metadata_json"},
                created_at: {columnName: "created_at"},
                updated_at: {columnName: "updated_at"},
                voterId: {columnName: "voterId"},
                proposalId: {columnName: "proposalId"},
                "voter.id": {relation: {entityName: "voter", refField: "id"}},
                "voter.email": {relation: {entityName: "voter", refField: "email"}},
                "voter.username": {relation: {entityName: "voter", refField: "username"}},
                "voter.full_name": {relation: {entityName: "voter", refField: "full_name"}},
                "voter.auth_id": {relation: {entityName: "voter", refField: "auth_id"}},
                "voter.role": {relation: {entityName: "voter", refField: "role"}},
                "voter.phone": {relation: {entityName: "voter", refField: "phone"}},
                "voter.address": {relation: {entityName: "voter", refField: "address"}},
                "voter.organization": {relation: {entityName: "voter", refField: "organization"}},
                "voter.ministry_affiliation": {relation: {entityName: "voter", refField: "ministry_affiliation"}},
                "voter.is_active": {relation: {entityName: "voter", refField: "is_active"}},
                "voter.email_verified": {relation: {entityName: "voter", refField: "email_verified"}},
                "voter.created_at": {relation: {entityName: "voter", refField: "created_at"}},
                "voter.updated_at": {relation: {entityName: "voter", refField: "updated_at"}},
                "proposal.id": {relation: {entityName: "proposal", refField: "id"}},
                "proposal.title": {relation: {entityName: "proposal", refField: "title"}},
                "proposal.description": {relation: {entityName: "proposal", refField: "description"}},
                "proposal.proposal_type": {relation: {entityName: "proposal", refField: "proposal_type"}},
                "proposal.ministry": {relation: {entityName: "proposal", refField: "ministry"}},
                "proposal.department": {relation: {entityName: "proposal", refField: "department"}},
                "proposal.affected_areas_json": {relation: {entityName: "proposal", refField: "affected_areas_json"}},
                "proposal.estimated_cost": {relation: {entityName: "proposal", refField: "estimated_cost"}},
                "proposal.funding_source": {relation: {entityName: "proposal", refField: "funding_source"}},
                "proposal.cost_breakdown_json": {relation: {entityName: "proposal", refField: "cost_breakdown_json"}},
                "proposal.proposed_start_date": {relation: {entityName: "proposal", refField: "proposed_start_date"}},
                "proposal.proposed_end_date": {relation: {entityName: "proposal", refField: "proposed_end_date"}},
                "proposal.implementation_plan": {relation: {entityName: "proposal", refField: "implementation_plan"}},
                "proposal.submitted_by_user_id": {relation: {entityName: "proposal", refField: "submitted_by_user_id"}},
                "proposal.supporting_organizations_json": {relation: {entityName: "proposal", refField: "supporting_organizations_json"}},
                "proposal.votes_for": {relation: {entityName: "proposal", refField: "votes_for"}},
                "proposal.votes_against": {relation: {entityName: "proposal", refField: "votes_against"}},
                "proposal.votes_abstain": {relation: {entityName: "proposal", refField: "votes_abstain"}},
                "proposal.status": {relation: {entityName: "proposal", refField: "status"}},
                "proposal.assigned_reviewer_user_id": {relation: {entityName: "proposal", refField: "assigned_reviewer_user_id"}},
                "proposal.committee_assigned": {relation: {entityName: "proposal", refField: "committee_assigned"}},
                "proposal.public_voting_enabled": {relation: {entityName: "proposal", refField: "public_voting_enabled"}},
                "proposal.voting_start_date": {relation: {entityName: "proposal", refField: "voting_start_date"}},
                "proposal.voting_end_date": {relation: {entityName: "proposal", refField: "voting_end_date"}},
                "proposal.supporting_documents_json": {relation: {entityName: "proposal", refField: "supporting_documents_json"}},
                "proposal.impact_assessment": {relation: {entityName: "proposal", refField: "impact_assessment"}},
                "proposal.created_at": {relation: {entityName: "proposal", refField: "created_at"}},
                "proposal.updated_at": {relation: {entityName: "proposal", refField: "updated_at"}},
                "proposal.last_reviewed_date": {relation: {entityName: "proposal", refField: "last_reviewed_date"}},
                "proposal.submitted_byId": {relation: {entityName: "proposal", refField: "submitted_byId"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                voter: {entity: User, fieldName: "voter", refTable: "User", refColumns: ["id"], joinColumns: ["voterId"], 'type: psql:ONE_TO_MANY},
                proposal: {entity: Proposal, fieldName: "proposal", refTable: "Proposal", refColumns: ["id"], joinColumns: ["proposalId"], 'type: psql:ONE_TO_MANY}
            }
        },
        [PROPOSAL]: {
            entityName: "Proposal",
            tableName: "Proposal",
            fieldMetadata: {
                id: {columnName: "id"},
                title: {columnName: "title"},
                description: {columnName: "description"},
                proposal_type: {columnName: "proposal_type"},
                ministry: {columnName: "ministry"},
                department: {columnName: "department"},
                affected_areas_json: {columnName: "affected_areas_json"},
                estimated_cost: {columnName: "estimated_cost"},
                funding_source: {columnName: "funding_source"},
                cost_breakdown_json: {columnName: "cost_breakdown_json"},
                proposed_start_date: {columnName: "proposed_start_date"},
                proposed_end_date: {columnName: "proposed_end_date"},
                implementation_plan: {columnName: "implementation_plan"},
                submitted_by_user_id: {columnName: "submitted_by_user_id"},
                supporting_organizations_json: {columnName: "supporting_organizations_json"},
                votes_for: {columnName: "votes_for"},
                votes_against: {columnName: "votes_against"},
                votes_abstain: {columnName: "votes_abstain"},
                status: {columnName: "status"},
                assigned_reviewer_user_id: {columnName: "assigned_reviewer_user_id"},
                committee_assigned: {columnName: "committee_assigned"},
                public_voting_enabled: {columnName: "public_voting_enabled"},
                voting_start_date: {columnName: "voting_start_date"},
                voting_end_date: {columnName: "voting_end_date"},
                supporting_documents_json: {columnName: "supporting_documents_json"},
                impact_assessment: {columnName: "impact_assessment"},
                created_at: {columnName: "created_at"},
                updated_at: {columnName: "updated_at"},
                last_reviewed_date: {columnName: "last_reviewed_date"},
                submitted_byId: {columnName: "submitted_byId"},
                "submitted_by.id": {relation: {entityName: "submitted_by", refField: "id"}},
                "submitted_by.email": {relation: {entityName: "submitted_by", refField: "email"}},
                "submitted_by.username": {relation: {entityName: "submitted_by", refField: "username"}},
                "submitted_by.full_name": {relation: {entityName: "submitted_by", refField: "full_name"}},
                "submitted_by.auth_id": {relation: {entityName: "submitted_by", refField: "auth_id"}},
                "submitted_by.role": {relation: {entityName: "submitted_by", refField: "role"}},
                "submitted_by.phone": {relation: {entityName: "submitted_by", refField: "phone"}},
                "submitted_by.address": {relation: {entityName: "submitted_by", refField: "address"}},
                "submitted_by.organization": {relation: {entityName: "submitted_by", refField: "organization"}},
                "submitted_by.ministry_affiliation": {relation: {entityName: "submitted_by", refField: "ministry_affiliation"}},
                "submitted_by.is_active": {relation: {entityName: "submitted_by", refField: "is_active"}},
                "submitted_by.email_verified": {relation: {entityName: "submitted_by", refField: "email_verified"}},
                "submitted_by.created_at": {relation: {entityName: "submitted_by", refField: "created_at"}},
                "submitted_by.updated_at": {relation: {entityName: "submitted_by", refField: "updated_at"}},
                "votes[].id": {relation: {entityName: "votes", refField: "id"}},
                "votes[].vote_type": {relation: {entityName: "votes", refField: "vote_type"}},
                "votes[].vote_reason": {relation: {entityName: "votes", refField: "vote_reason"}},
                "votes[].votable_type": {relation: {entityName: "votes", refField: "votable_type"}},
                "votes[].votable_id": {relation: {entityName: "votes", refField: "votable_id"}},
                "votes[].voter_user_id": {relation: {entityName: "votes", refField: "voter_user_id"}},
                "votes[].voter_role_at_time": {relation: {entityName: "votes", refField: "voter_role_at_time"}},
                "votes[].is_public_vote": {relation: {entityName: "votes", refField: "is_public_vote"}},
                "votes[].voting_session_id": {relation: {entityName: "votes", refField: "voting_session_id"}},
                "votes[].vote_metadata_json": {relation: {entityName: "votes", refField: "vote_metadata_json"}},
                "votes[].created_at": {relation: {entityName: "votes", refField: "created_at"}},
                "votes[].updated_at": {relation: {entityName: "votes", refField: "updated_at"}},
                "votes[].voterId": {relation: {entityName: "votes", refField: "voterId"}},
                "votes[].proposalId": {relation: {entityName: "votes", refField: "proposalId"}},
                "comments[].id": {relation: {entityName: "comments", refField: "id"}},
                "comments[].content": {relation: {entityName: "comments", refField: "content"}},
                "comments[].comment_type": {relation: {entityName: "comments", refField: "comment_type"}},
                "comments[].commentable_type": {relation: {entityName: "comments", refField: "commentable_type"}},
                "comments[].commentable_id": {relation: {entityName: "comments", refField: "commentable_id"}},
                "comments[].parent_comment_id": {relation: {entityName: "comments", refField: "parent_comment_id"}},
                "comments[].thread_level": {relation: {entityName: "comments", refField: "thread_level"}},
                "comments[].author_user_id": {relation: {entityName: "comments", refField: "author_user_id"}},
                "comments[].is_anonymous": {relation: {entityName: "comments", refField: "is_anonymous"}},
                "comments[].status": {relation: {entityName: "comments", refField: "status"}},
                "comments[].moderated_by_user_id": {relation: {entityName: "comments", refField: "moderated_by_user_id"}},
                "comments[].moderation_reason": {relation: {entityName: "comments", refField: "moderation_reason"}},
                "comments[].likes_count": {relation: {entityName: "comments", refField: "likes_count"}},
                "comments[].replies_count": {relation: {entityName: "comments", refField: "replies_count"}},
                "comments[].is_pinned": {relation: {entityName: "comments", refField: "is_pinned"}},
                "comments[].created_at": {relation: {entityName: "comments", refField: "created_at"}},
                "comments[].updated_at": {relation: {entityName: "comments", refField: "updated_at"}},
                "comments[].moderated_at": {relation: {entityName: "comments", refField: "moderated_at"}},
                "comments[].authorId": {relation: {entityName: "comments", refField: "authorId"}},
                "comments[].policyId": {relation: {entityName: "comments", refField: "policyId"}},
                "comments[].budget_categoryId": {relation: {entityName: "comments", refField: "budget_categoryId"}},
                "comments[].proposalId": {relation: {entityName: "comments", refField: "proposalId"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                submitted_by: {entity: User, fieldName: "submitted_by", refTable: "User", refColumns: ["id"], joinColumns: ["submitted_byId"], 'type: psql:ONE_TO_MANY},
                votes: {entity: Vote, fieldName: "votes", refTable: "Vote", refColumns: ["proposalId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                comments: {entity: Comment, fieldName: "comments", refTable: "Comment", refColumns: ["proposalId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}
            }
        },
        [POLICY_AMENDMENT]: {
            entityName: "PolicyAmendment",
            tableName: "PolicyAmendment",
            fieldMetadata: {
                id: {columnName: "id"},
                amendment_title: {columnName: "amendment_title"},
                amendment_description: {columnName: "amendment_description"},
                amendment_type: {columnName: "amendment_type"},
                policy_id: {columnName: "policy_id"},
                original_content_json: {columnName: "original_content_json"},
                amended_content_json: {columnName: "amended_content_json"},
                justification: {columnName: "justification"},
                status: {columnName: "status"},
                proposed_by_user_id: {columnName: "proposed_by_user_id"},
                approved_by_user_id: {columnName: "approved_by_user_id"},
                effective_date: {columnName: "effective_date"},
                is_emergency_amendment: {columnName: "is_emergency_amendment"},
                created_at: {columnName: "created_at"},
                updated_at: {columnName: "updated_at"},
                policyId: {columnName: "policyId"},
                proposed_byId: {columnName: "proposed_byId"},
                "policy.id": {relation: {entityName: "policy", refField: "id"}},
                "policy.name": {relation: {entityName: "policy", refField: "name"}},
                "policy.description": {relation: {entityName: "policy", refField: "description"}},
                "policy.policy_number": {relation: {entityName: "policy", refField: "policy_number"}},
                "policy.view_full_policy": {relation: {entityName: "policy", refField: "view_full_policy"}},
                "policy.policy_document_json": {relation: {entityName: "policy", refField: "policy_document_json"}},
                "policy.ministry": {relation: {entityName: "policy", refField: "ministry"}},
                "policy.department": {relation: {entityName: "policy", refField: "department"}},
                "policy.issuing_authority": {relation: {entityName: "policy", refField: "issuing_authority"}},
                "policy.status": {relation: {entityName: "policy", refField: "status"}},
                "policy.policy_type": {relation: {entityName: "policy", refField: "policy_type"}},
                "policy.priority_level": {relation: {entityName: "policy", refField: "priority_level"}},
                "policy.effective_date": {relation: {entityName: "policy", refField: "effective_date"}},
                "policy.expiry_date": {relation: {entityName: "policy", refField: "expiry_date"}},
                "policy.implementation_status": {relation: {entityName: "policy", refField: "implementation_status"}},
                "policy.legal_reference": {relation: {entityName: "policy", refField: "legal_reference"}},
                "policy.parent_legislation": {relation: {entityName: "policy", refField: "parent_legislation"}},
                "policy.affected_sectors_json": {relation: {entityName: "policy", refField: "affected_sectors_json"}},
                "policy.public_consultation_required": {relation: {entityName: "policy", refField: "public_consultation_required"}},
                "policy.consultation_start_date": {relation: {entityName: "policy", refField: "consultation_start_date"}},
                "policy.consultation_end_date": {relation: {entityName: "policy", refField: "consultation_end_date"}},
                "policy.authored_by_user_id": {relation: {entityName: "policy", refField: "authored_by_user_id"}},
                "policy.approved_by_user_id": {relation: {entityName: "policy", refField: "approved_by_user_id"}},
                "policy.reviewed_by_user_id": {relation: {entityName: "policy", refField: "reviewed_by_user_id"}},
                "policy.tags_json": {relation: {entityName: "policy", refField: "tags_json"}},
                "policy.metadata_json": {relation: {entityName: "policy", refField: "metadata_json"}},
                "policy.created_at": {relation: {entityName: "policy", refField: "created_at"}},
                "policy.updated_at": {relation: {entityName: "policy", refField: "updated_at"}},
                "policy.last_reviewed_date": {relation: {entityName: "policy", refField: "last_reviewed_date"}},
                "policy.authored_byId": {relation: {entityName: "policy", refField: "authored_byId"}},
                "proposed_by.id": {relation: {entityName: "proposed_by", refField: "id"}},
                "proposed_by.email": {relation: {entityName: "proposed_by", refField: "email"}},
                "proposed_by.username": {relation: {entityName: "proposed_by", refField: "username"}},
                "proposed_by.full_name": {relation: {entityName: "proposed_by", refField: "full_name"}},
                "proposed_by.auth_id": {relation: {entityName: "proposed_by", refField: "auth_id"}},
                "proposed_by.role": {relation: {entityName: "proposed_by", refField: "role"}},
                "proposed_by.phone": {relation: {entityName: "proposed_by", refField: "phone"}},
                "proposed_by.address": {relation: {entityName: "proposed_by", refField: "address"}},
                "proposed_by.organization": {relation: {entityName: "proposed_by", refField: "organization"}},
                "proposed_by.ministry_affiliation": {relation: {entityName: "proposed_by", refField: "ministry_affiliation"}},
                "proposed_by.is_active": {relation: {entityName: "proposed_by", refField: "is_active"}},
                "proposed_by.email_verified": {relation: {entityName: "proposed_by", refField: "email_verified"}},
                "proposed_by.created_at": {relation: {entityName: "proposed_by", refField: "created_at"}},
                "proposed_by.updated_at": {relation: {entityName: "proposed_by", refField: "updated_at"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                policy: {entity: Policy, fieldName: "policy", refTable: "Policy", refColumns: ["id"], joinColumns: ["policyId"], 'type: psql:ONE_TO_MANY},
                proposed_by: {entity: User, fieldName: "proposed_by", refTable: "User", refColumns: ["id"], joinColumns: ["proposed_byId"], 'type: psql:ONE_TO_MANY}
            }
        }
    };

    public isolated function init() returns persist:Error? {
        postgresql:Client|error dbClient = new (host = host, username = user, password = password, database = database, port = port, options = connectionOptions);
        if dbClient is error {
            return <persist:Error>error(dbClient.message());
        }
        self.dbClient = dbClient;
        if defaultSchema != () {
            lock {
                foreach string key in self.metadata.keys() {
                    psql:SQLMetadata metadata = self.metadata.get(key);
                    if metadata.schemaName == () {
                        metadata.schemaName = defaultSchema;
                    }
                    map<psql:JoinMetadata>? joinMetadataMap = metadata.joinMetadata;
                    if joinMetadataMap == () {
                        continue;
                    }
                    foreach [string, psql:JoinMetadata] [_, joinMetadata] in joinMetadataMap.entries() {
                        if joinMetadata.refSchema == () {
                            joinMetadata.refSchema = defaultSchema;
                        }
                    }
                }
            }
        }
        self.persistClients = {
            [USER]: check new (dbClient, self.metadata.get(USER).cloneReadOnly(), psql:POSTGRESQL_SPECIFICS),
            [BUDGET_CATEGORY]: check new (dbClient, self.metadata.get(BUDGET_CATEGORY).cloneReadOnly(), psql:POSTGRESQL_SPECIFICS),
            [POLICY]: check new (dbClient, self.metadata.get(POLICY).cloneReadOnly(), psql:POSTGRESQL_SPECIFICS),
            [BUDGET_TRANSACTION]: check new (dbClient, self.metadata.get(BUDGET_TRANSACTION).cloneReadOnly(), psql:POSTGRESQL_SPECIFICS),
            [COMMENT]: check new (dbClient, self.metadata.get(COMMENT).cloneReadOnly(), psql:POSTGRESQL_SPECIFICS),
            [VOTE]: check new (dbClient, self.metadata.get(VOTE).cloneReadOnly(), psql:POSTGRESQL_SPECIFICS),
            [PROPOSAL]: check new (dbClient, self.metadata.get(PROPOSAL).cloneReadOnly(), psql:POSTGRESQL_SPECIFICS),
            [POLICY_AMENDMENT]: check new (dbClient, self.metadata.get(POLICY_AMENDMENT).cloneReadOnly(), psql:POSTGRESQL_SPECIFICS)
        };
    }

    isolated resource function get users(UserTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get users/[string id](UserTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post users(UserInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from UserInsert inserted in data
            select inserted.id;
    }

    isolated resource function put users/[string id](UserUpdate value) returns User|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/users/[id].get();
    }

    isolated resource function delete users/[string id]() returns User|persist:Error {
        User result = check self->/users/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get budgetcategories(BudgetCategoryTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get budgetcategories/[int id](BudgetCategoryTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post budgetcategories(BudgetCategoryInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(BUDGET_CATEGORY);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from BudgetCategoryInsert inserted in data
            select inserted.id;
    }

    isolated resource function put budgetcategories/[int id](BudgetCategoryUpdate value) returns BudgetCategory|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(BUDGET_CATEGORY);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/budgetcategories/[id].get();
    }

    isolated resource function delete budgetcategories/[int id]() returns BudgetCategory|persist:Error {
        BudgetCategory result = check self->/budgetcategories/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(BUDGET_CATEGORY);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get policies(PolicyTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get policies/[int id](PolicyTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post policies(PolicyInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLICY);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from PolicyInsert inserted in data
            select inserted.id;
    }

    isolated resource function put policies/[int id](PolicyUpdate value) returns Policy|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLICY);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/policies/[id].get();
    }

    isolated resource function delete policies/[int id]() returns Policy|persist:Error {
        Policy result = check self->/policies/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLICY);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get budgettransactions(BudgetTransactionTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get budgettransactions/[string id](BudgetTransactionTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post budgettransactions(BudgetTransactionInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(BUDGET_TRANSACTION);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from BudgetTransactionInsert inserted in data
            select inserted.id;
    }

    isolated resource function put budgettransactions/[string id](BudgetTransactionUpdate value) returns BudgetTransaction|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(BUDGET_TRANSACTION);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/budgettransactions/[id].get();
    }

    isolated resource function delete budgettransactions/[string id]() returns BudgetTransaction|persist:Error {
        BudgetTransaction result = check self->/budgettransactions/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(BUDGET_TRANSACTION);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get comments(CommentTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get comments/[string id](CommentTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post comments(CommentInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(COMMENT);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from CommentInsert inserted in data
            select inserted.id;
    }

    isolated resource function put comments/[string id](CommentUpdate value) returns Comment|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(COMMENT);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/comments/[id].get();
    }

    isolated resource function delete comments/[string id]() returns Comment|persist:Error {
        Comment result = check self->/comments/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(COMMENT);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get votes(VoteTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get votes/[string id](VoteTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post votes(VoteInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(VOTE);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from VoteInsert inserted in data
            select inserted.id;
    }

    isolated resource function put votes/[string id](VoteUpdate value) returns Vote|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(VOTE);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/votes/[id].get();
    }

    isolated resource function delete votes/[string id]() returns Vote|persist:Error {
        Vote result = check self->/votes/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(VOTE);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get proposals(ProposalTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get proposals/[string id](ProposalTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post proposals(ProposalInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(PROPOSAL);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from ProposalInsert inserted in data
            select inserted.id;
    }

    isolated resource function put proposals/[string id](ProposalUpdate value) returns Proposal|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(PROPOSAL);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/proposals/[id].get();
    }

    isolated resource function delete proposals/[string id]() returns Proposal|persist:Error {
        Proposal result = check self->/proposals/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(PROPOSAL);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get policyamendments(PolicyAmendmentTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get policyamendments/[string id](PolicyAmendmentTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post policyamendments(PolicyAmendmentInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLICY_AMENDMENT);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from PolicyAmendmentInsert inserted in data
            select inserted.id;
    }

    isolated resource function put policyamendments/[string id](PolicyAmendmentUpdate value) returns PolicyAmendment|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLICY_AMENDMENT);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/policyamendments/[id].get();
    }

    isolated resource function delete policyamendments/[string id]() returns PolicyAmendment|persist:Error {
        PolicyAmendment result = check self->/policyamendments/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLICY_AMENDMENT);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    remote isolated function queryNativeSQL(sql:ParameterizedQuery sqlQuery, typedesc<record {}> rowType = <>) returns stream<rowType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor"
    } external;

    remote isolated function executeNativeSQL(sql:ParameterizedQuery sqlQuery) returns psql:ExecutionResult|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor"
    } external;

    public isolated function close() returns persist:Error? {
        error? result = self.dbClient.close();
        if result is error {
            return <persist:Error>error(result.message());
        }
        return result;
    }
}

