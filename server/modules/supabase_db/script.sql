-- AUTO-GENERATED FILE.

-- This file is an auto-generated file by Ballerina persistence layer for model.
-- Please verify the generated scripts and execute them against the target DB server.

DROP TABLE IF EXISTS "Comment";
DROP TABLE IF EXISTS "PolicyAmendment";
DROP TABLE IF EXISTS "Policy";
DROP TABLE IF EXISTS "BudgetTransaction";
DROP TABLE IF EXISTS "BudgetCategory";
DROP TABLE IF EXISTS "Vote";
DROP TABLE IF EXISTS "Proposal";
DROP TABLE IF EXISTS "User";

CREATE TABLE "User" (
	"id" VARCHAR(191) NOT NULL,
	"email" VARCHAR(191) NOT NULL,
	"username" VARCHAR(191),
	"full_name" VARCHAR(191),
	"auth_id" VARCHAR(191),
	"role" VARCHAR(191) NOT NULL,
	"phone" VARCHAR(191),
	"address" VARCHAR(191),
	"organization" VARCHAR(191),
	"ministry_affiliation" VARCHAR(191),
	"is_active" BOOLEAN NOT NULL,
	"email_verified" BOOLEAN NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"updated_at" TIMESTAMP NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE "Proposal" (
	"id" VARCHAR(191) NOT NULL,
	"title" VARCHAR(191) NOT NULL,
	"description" VARCHAR(191) NOT NULL,
	"proposal_type" VARCHAR(191) NOT NULL,
	"ministry" VARCHAR(191),
	"department" VARCHAR(191),
	"affected_areas_json" VARCHAR(191),
	"estimated_cost" DECIMAL(65,30),
	"funding_source" VARCHAR(191),
	"cost_breakdown_json" VARCHAR(191),
	"proposed_start_date" TIMESTAMP,
	"proposed_end_date" TIMESTAMP,
	"implementation_plan" VARCHAR(191),
	"submitted_by_user_id" VARCHAR(191) NOT NULL,
	"supporting_organizations_json" VARCHAR(191),
	"votes_for" INT NOT NULL,
	"votes_against" INT NOT NULL,
	"votes_abstain" INT NOT NULL,
	"status" VARCHAR(191) NOT NULL,
	"assigned_reviewer_user_id" VARCHAR(191),
	"committee_assigned" VARCHAR(191),
	"public_voting_enabled" BOOLEAN NOT NULL,
	"voting_start_date" TIMESTAMP,
	"voting_end_date" TIMESTAMP,
	"supporting_documents_json" VARCHAR(191),
	"impact_assessment" VARCHAR(191),
	"created_at" TIMESTAMP NOT NULL,
	"updated_at" TIMESTAMP NOT NULL,
	"last_reviewed_date" TIMESTAMP,
	"submitted_byId" VARCHAR(191) NOT NULL,
	FOREIGN KEY("submitted_byId") REFERENCES "User"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "Vote" (
	"id" VARCHAR(191) NOT NULL,
	"vote_type" VARCHAR(191) NOT NULL,
	"vote_reason" VARCHAR(191),
	"votable_type" VARCHAR(191) NOT NULL,
	"votable_id" VARCHAR(191) NOT NULL,
	"voter_user_id" VARCHAR(191) NOT NULL,
	"voter_role_at_time" VARCHAR(191),
	"is_public_vote" BOOLEAN NOT NULL,
	"voting_session_id" VARCHAR(191),
	"vote_metadata_json" VARCHAR(191),
	"created_at" TIMESTAMP NOT NULL,
	"updated_at" TIMESTAMP,
	"voterId" VARCHAR(191) NOT NULL,
	FOREIGN KEY("voterId") REFERENCES "User"("id"),
	"proposalId" VARCHAR(191) NOT NULL,
	FOREIGN KEY("proposalId") REFERENCES "Proposal"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "BudgetCategory" (
	"id" INT NOT NULL,
	"category_name" VARCHAR(191) NOT NULL,
	"description" VARCHAR(191),
	"allocated_budget" DECIMAL(65,30) NOT NULL,
	"spent_budget" DECIMAL(65,30) NOT NULL,
	"reserved_budget" DECIMAL(65,30),
	"fiscal_year" VARCHAR(191) NOT NULL,
	"ministry" VARCHAR(191),
	"department" VARCHAR(191),
	"status" VARCHAR(191) NOT NULL,
	"approval_authority" VARCHAR(191),
	"budget_source" VARCHAR(191),
	"tracking_code" VARCHAR(191),
	"budget_breakdown_json" VARCHAR(191),
	"created_by_user_id" VARCHAR(191) NOT NULL,
	"last_modified_by_user_id" VARCHAR(191),
	"created_at" TIMESTAMP NOT NULL,
	"updated_at" TIMESTAMP NOT NULL,
	"approval_date" TIMESTAMP,
	"created_byId" VARCHAR(191) NOT NULL,
	FOREIGN KEY("created_byId") REFERENCES "User"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "BudgetTransaction" (
	"id" VARCHAR(191) NOT NULL,
	"transaction_type" VARCHAR(191) NOT NULL,
	"amount" DECIMAL(65,30) NOT NULL,
	"description" VARCHAR(191) NOT NULL,
	"budget_category_id" INT NOT NULL,
	"transaction_reference" VARCHAR(191),
	"invoice_number" VARCHAR(191),
	"vendor_information" VARCHAR(191),
	"status" VARCHAR(191) NOT NULL,
	"approved_by_user_id" VARCHAR(191),
	"executed_by_user_id" VARCHAR(191),
	"accounting_code" VARCHAR(191),
	"cost_center" VARCHAR(191),
	"line_items_json" VARCHAR(191),
	"compliance_status" VARCHAR(191),
	"audit_notes" VARCHAR(191),
	"requires_additional_approval" BOOLEAN NOT NULL,
	"supporting_documents_json" VARCHAR(191),
	"attachment_urls" VARCHAR(191),
	"created_at" TIMESTAMP NOT NULL,
	"updated_at" TIMESTAMP NOT NULL,
	"transaction_date" TIMESTAMP,
	"approval_date" TIMESTAMP,
	"execution_date" TIMESTAMP,
	"budget_categoryId" INT NOT NULL,
	FOREIGN KEY("budget_categoryId") REFERENCES "BudgetCategory"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "Policy" (
	"id" INT NOT NULL,
	"name" VARCHAR(191) NOT NULL,
	"description" VARCHAR(191) NOT NULL,
	"policy_number" VARCHAR(191) NOT NULL,
	"view_full_policy" VARCHAR(191) NOT NULL,
	"policy_document_json" VARCHAR(191),
	"ministry" VARCHAR(191) NOT NULL,
	"department" VARCHAR(191),
	"issuing_authority" VARCHAR(191),
	"status" VARCHAR(191) NOT NULL,
	"policy_type" VARCHAR(191),
	"priority_level" VARCHAR(191),
	"effective_date" TIMESTAMP,
	"expiry_date" TIMESTAMP,
	"implementation_status" VARCHAR(191),
	"legal_reference" VARCHAR(191),
	"parent_legislation" VARCHAR(191),
	"affected_sectors_json" VARCHAR(191),
	"public_consultation_required" BOOLEAN NOT NULL,
	"consultation_start_date" TIMESTAMP,
	"consultation_end_date" TIMESTAMP,
	"authored_by_user_id" VARCHAR(191) NOT NULL,
	"approved_by_user_id" VARCHAR(191),
	"reviewed_by_user_id" VARCHAR(191),
	"tags_json" VARCHAR(191),
	"metadata_json" VARCHAR(191),
	"created_at" TIMESTAMP NOT NULL,
	"updated_at" TIMESTAMP NOT NULL,
	"last_reviewed_date" TIMESTAMP,
	"authored_byId" VARCHAR(191) NOT NULL,
	FOREIGN KEY("authored_byId") REFERENCES "User"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "PolicyAmendment" (
	"id" VARCHAR(191) NOT NULL,
	"amendment_title" VARCHAR(191) NOT NULL,
	"amendment_description" VARCHAR(191) NOT NULL,
	"amendment_type" VARCHAR(191) NOT NULL,
	"policy_id" INT NOT NULL,
	"original_content_json" VARCHAR(191),
	"amended_content_json" VARCHAR(191),
	"justification" VARCHAR(191),
	"status" VARCHAR(191) NOT NULL,
	"proposed_by_user_id" VARCHAR(191) NOT NULL,
	"approved_by_user_id" VARCHAR(191),
	"effective_date" TIMESTAMP,
	"is_emergency_amendment" BOOLEAN NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"updated_at" TIMESTAMP NOT NULL,
	"policyId" INT NOT NULL,
	FOREIGN KEY("policyId") REFERENCES "Policy"("id"),
	"proposed_byId" VARCHAR(191) NOT NULL,
	FOREIGN KEY("proposed_byId") REFERENCES "User"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "Comment" (
	"id" VARCHAR(191) NOT NULL,
	"content" VARCHAR(191) NOT NULL,
	"comment_type" VARCHAR(191) NOT NULL,
	"commentable_type" VARCHAR(191) NOT NULL,
	"commentable_id" VARCHAR(191) NOT NULL,
	"parent_comment_id" VARCHAR(191),
	"thread_level" INT NOT NULL,
	"author_user_id" VARCHAR(191) NOT NULL,
	"is_anonymous" BOOLEAN NOT NULL,
	"status" VARCHAR(191) NOT NULL,
	"moderated_by_user_id" VARCHAR(191),
	"moderation_reason" VARCHAR(191),
	"likes_count" INT NOT NULL,
	"replies_count" INT NOT NULL,
	"is_pinned" BOOLEAN NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"updated_at" TIMESTAMP NOT NULL,
	"moderated_at" TIMESTAMP,
	"authorId" VARCHAR(191) NOT NULL,
	FOREIGN KEY("authorId") REFERENCES "User"("id"),
	"policyId" INT NOT NULL,
	FOREIGN KEY("policyId") REFERENCES "Policy"("id"),
	"budget_categoryId" INT NOT NULL,
	FOREIGN KEY("budget_categoryId") REFERENCES "BudgetCategory"("id"),
	"proposalId" VARCHAR(191) NOT NULL,
	FOREIGN KEY("proposalId") REFERENCES "Proposal"("id"),
	PRIMARY KEY("id")
);


