// Supabase Database Service Implementation using Ballerina Persist
// This service provides a comprehensive data access layer for the Transparent Governance Platform
// using the generated persist client with Supabase PostgreSQL integration

import server_bal.supabase_db as db;
import ballerina/log;
import ballerina/time;
import ballerina/uuid;
import ballerina/persist;
import ballerina/sql;

// Supabase Database Service
public isolated service class SupabaseDbService {
    private final db:Client dbClient;
    
    public isolated function init() returns error? {
        self.dbClient = check new ();
        log:printInfo("✅ Supabase database client initialized successfully");
    }
    
    // === User Management Operations ===
    
    # Create a new user in the system
    #
    # + userData - User data to create
    # + return - Created user ID or error
    public isolated function createUser(UserCreateData userData) returns string|error {
        string userId = uuid:createType1AsString();
        
        db:UserInsert userInsert = {
            id: userId,
            email: userData.email,
            username: userData.username,
            full_name: userData.full_name,
            auth_id: userData.auth_id,
            role: userData.role,
            phone: userData.phone,
            address: userData.address,
            organization: userData.organization,
            ministry_affiliation: userData.ministry_affiliation,
            is_active: true,
            email_verified: false,
            created_at: time:utcNow(),
            updated_at: time:utcNow()
        };
        
        string[] result = check self.dbClient->/users.post([userInsert]);
        log:printInfo("Created user with ID: " + result[0]);
        return result[0];
    }
    
    # Get user by ID
    #
    # + userId - User ID to retrieve
    # + return - User data or error
    public isolated function getUserById(string userId) returns db:User|error {
        return self.dbClient->/users/[userId].get();
    }
    
    # Get user by email
    #
    # + email - User email to search for
    # + return - User data or error
    public isolated function getUserByEmail(string email) returns db:User|error {
        stream<db:User, persist:Error?> userStream = self.dbClient->/users.get(
            whereClause = `WHERE email = ${email}`
        );
        
        record {|db:User value;|}? result = check userStream.next();
        check userStream.close();
        
        if result is () {
            return error("User not found with email: " + email);
        }
        
        return result.value;
    }
    
    # Update user information
    #
    # + userId - User ID to update
    # + updateData - Data to update
    # + return - Updated user or error
    public isolated function updateUser(string userId, UserUpdateData updateData) returns db:User|error {
        db:UserUpdate userUpdate = {
            email: updateData.email,
            username: updateData.username,
            full_name: updateData.full_name,
            phone: updateData.phone,
            address: updateData.address,
            organization: updateData.organization,
            ministry_affiliation: updateData.ministry_affiliation,
            updated_at: time:utcNow()
        };
        
        return self.dbClient->/users/[userId].put(userUpdate);
    }
    
    # Get all users with pagination
    #
    # + 'limit - Number of users to return
    # + offset - Number of users to skip
    # + return - Stream of users or error
    public isolated function getAllUsers(int 'limit = 50, int offset = 0) returns stream<db:User, persist:Error?>|error {
        return self.dbClient->/users.get(
            limitClause = `LIMIT ${'limit} OFFSET ${offset}`,
            orderByClause = `ORDER BY created_at DESC`
        );
    }
    
    // === Budget Category Operations ===
    
    # Create a new budget category
    #
    # + categoryData - Budget category data
    # + createdByUserId - ID of user creating the category
    # + return - Created category ID or error
    public isolated function createBudgetCategory(BudgetCategoryCreateData categoryData, string createdByUserId) returns int|error {
        db:BudgetCategoryInsert categoryInsert = {
            id: categoryData.id ?: 0, // Auto-increment if not provided
            category_name: categoryData.category_name,
            description: categoryData.description,
            allocated_budget: categoryData.allocated_budget,
            spent_budget: categoryData.spent_budget ?: 0.0,
            reserved_budget: categoryData.reserved_budget,
            fiscal_year: categoryData.fiscal_year,
            ministry: categoryData.ministry,
            department: categoryData.department,
            status: categoryData.status ?: "PROPOSED",
            approval_authority: categoryData.approval_authority,
            budget_source: categoryData.budget_source,
            tracking_code: categoryData.tracking_code,
            budget_breakdown_json: categoryData.budget_breakdown_json,
            created_by_user_id: createdByUserId,
            last_modified_by_user_id: createdByUserId,
            created_at: time:utcNow(),
            updated_at: time:utcNow(),
            approval_date: (),
            created_byId: createdByUserId
        };
        
        int[] result = check self.dbClient->/budgetcategories.post([categoryInsert]);
        log:printInfo("Created budget category with ID: " + result[0].toString());
        return result[0];
    }
    
    # Get budget category by ID
    #
    # + categoryId - Category ID to retrieve
    # + return - Budget category data or error
    public isolated function getBudgetCategoryById(int categoryId) returns db:BudgetCategory|error {
        return self.dbClient->/budgetcategories/[categoryId].get();
    }
    
    # Get budget categories by ministry
    #
    # + ministry - Ministry name to filter by
    # + return - Stream of budget categories or error
    public isolated function getBudgetCategoriesByMinistry(string ministry) returns stream<db:BudgetCategory, persist:Error?>|error {
        return self.dbClient->/budgetcategories.get(
            whereClause = `WHERE ministry = ${ministry}`,
            orderByClause = `ORDER BY created_at DESC`
        );
    }
    
    # Get budget categories by fiscal year
    #
    # + fiscalYear - Fiscal year to filter by
    # + return - Stream of budget categories or error
    public isolated function getBudgetCategoriesByFiscalYear(string fiscalYear) returns stream<db:BudgetCategory, persist:Error?>|error {
        return self.dbClient->/budgetcategories.get(
            whereClause = `WHERE fiscal_year = ${fiscalYear}`,
            orderByClause = `ORDER BY category_name ASC`
        );
    }
    
    # Update budget category
    #
    # + categoryId - Category ID to update
    # + updateData - Data to update
    # + modifiedByUserId - ID of user modifying the category
    # + return - Updated category or error
    public isolated function updateBudgetCategory(int categoryId, BudgetCategoryUpdateData updateData, string modifiedByUserId) returns db:BudgetCategory|error {
        db:BudgetCategoryUpdate categoryUpdate = {
            category_name: updateData.category_name,
            description: updateData.description,
            allocated_budget: updateData.allocated_budget,
            spent_budget: updateData.spent_budget,
            reserved_budget: updateData.reserved_budget,
            status: updateData.status,
            approval_authority: updateData.approval_authority,
            budget_source: updateData.budget_source,
            tracking_code: updateData.tracking_code,
            budget_breakdown_json: updateData.budget_breakdown_json,
            last_modified_by_user_id: modifiedByUserId,
            updated_at: time:utcNow()
        };
        
        return self.dbClient->/budgetcategories/[categoryId].put(categoryUpdate);
    }
    
    // === Policy Operations ===
    
    # Create a new policy
    #
    # + policyData - Policy data to create
    # + authoredByUserId - ID of user creating the policy
    # + return - Created policy ID or error
    public isolated function createPolicy(PolicyCreateData policyData, string authoredByUserId) returns int|error {
        db:PolicyInsert policyInsert = {
            id: policyData.id ?: 0, // Auto-increment if not provided
            name: policyData.name,
            description: policyData.description,
            policy_number: policyData.policy_number,
            view_full_policy: policyData.view_full_policy,
            policy_document_json: policyData.policy_document_json,
            ministry: policyData.ministry,
            department: policyData.department,
            issuing_authority: policyData.issuing_authority,
            status: policyData.status ?: "DRAFT",
            policy_type: policyData.policy_type,
            priority_level: policyData.priority_level,
            effective_date: policyData.effective_date,
            expiry_date: policyData.expiry_date,
            implementation_status: policyData.implementation_status,
            legal_reference: policyData.legal_reference,
            parent_legislation: policyData.parent_legislation,
            affected_sectors_json: policyData.affected_sectors_json,
            public_consultation_required: policyData.public_consultation_required ?: false,
            consultation_start_date: policyData.consultation_start_date,
            consultation_end_date: policyData.consultation_end_date,
            authored_by_user_id: authoredByUserId,
            approved_by_user_id: (),
            reviewed_by_user_id: (),
            tags_json: policyData.tags_json,
            metadata_json: policyData.metadata_json,
            created_at: time:utcNow(),
            updated_at: time:utcNow(),
            last_reviewed_date: (),
            authored_byId: authoredByUserId
        };
        
        int[] result = check self.dbClient->/policies.post([policyInsert]);
        log:printInfo("Created policy with ID: " + result[0].toString());
        return result[0];
    }
    
    # Get policy by ID
    #
    # + policyId - Policy ID to retrieve
    # + return - Policy data or error
    public isolated function getPolicyById(int policyId) returns db:Policy|error {
        return self.dbClient->/policies/[policyId].get();
    }
    
    # Get policies by status
    #
    # + status - Policy status to filter by
    # + return - Stream of policies or error
    public isolated function getPoliciesByStatus(string status) returns stream<db:Policy, persist:Error?>|error {
        return self.dbClient->/policies.get(
            whereClause = `WHERE status = ${status}`,
            orderByClause = `ORDER BY created_at DESC`
        );
    }
    
    # Get policies by ministry
    #
    # + ministry - Ministry name to filter by
    # + return - Stream of policies or error
    public isolated function getPoliciesByMinistry(string ministry) returns stream<db:Policy, persist:Error?>|error {
        return self.dbClient->/policies.get(
            whereClause = `WHERE ministry = ${ministry}`,
            orderByClause = `ORDER BY created_at DESC`
        );
    }
    
    // === Raw SQL Operations for Complex Queries ===
    
    # Execute a custom SQL query for advanced analytics
    #
    # + sqlQuery - Parameterized SQL query
    # + return - Query results or error
    public isolated function executeCustomQuery(sql:ParameterizedQuery sqlQuery) returns stream<record {}, persist:Error?>|error {
        return self.dbClient->queryNativeSQL(sqlQuery);
    }
    
    # Get budget utilization summary by ministry
    #
    # + ministry - Ministry to analyze
    # + fiscalYear - Fiscal year to analyze
    # + return - Budget utilization data or error
    public isolated function getBudgetUtilizationByMinistry(string ministry, string fiscalYear) returns record {}[]|error {
        sql:ParameterizedQuery query = `
            SELECT 
                bc.ministry,
                bc.fiscal_year,
                SUM(bc.allocated_budget) as total_allocated,
                SUM(bc.spent_budget) as total_spent,
                SUM(bc.reserved_budget) as total_reserved,
                COUNT(bc.id) as category_count,
                CASE 
                    WHEN SUM(bc.allocated_budget) > 0 
                    THEN (SUM(bc.spent_budget) / SUM(bc.allocated_budget) * 100) 
                    ELSE 0 
                END as utilization_percentage
            FROM "BudgetCategory" bc
            WHERE bc.ministry = ${ministry} AND bc.fiscal_year = ${fiscalYear}
            GROUP BY bc.ministry, bc.fiscal_year
        `;
        
        stream<record {}, persist:Error?> resultStream = check self.dbClient->queryNativeSQL(query);
        return from record {} item in resultStream select item;
    }
    
    # Close database connection
    #
    # + return - Error if connection close fails
    public isolated function close() returns error? {
        return self.dbClient.close();
    }
}

// === Data Transfer Objects ===

# User creation data
public type UserCreateData record {|
    string email;
    string? username;
    string? full_name;
    string? auth_id;
    string role;
    string? phone;
    string? address;
    string? organization;
    string? ministry_affiliation;
|};

# User update data
public type UserUpdateData record {|
    string? email;
    string? username;
    string? full_name;
    string? phone;
    string? address;
    string? organization;
    string? ministry_affiliation;
|};

# Budget category creation data
public type BudgetCategoryCreateData record {|
    int? id;
    string category_name;
    string? description;
    decimal allocated_budget;
    decimal? spent_budget;
    decimal? reserved_budget;
    string fiscal_year;
    string? ministry;
    string? department;
    string? status;
    string? approval_authority;
    string? budget_source;
    string? tracking_code;
    string? budget_breakdown_json;
|};

# Budget category update data
public type BudgetCategoryUpdateData record {|
    string? category_name;
    string? description;
    decimal? allocated_budget;
    decimal? spent_budget;
    decimal? reserved_budget;
    string? status;
    string? approval_authority;
    string? budget_source;
    string? tracking_code;
    string? budget_breakdown_json;
|};

# Policy creation data
public type PolicyCreateData record {|
    int? id;
    string name;
    string description;
    string policy_number;
    string view_full_policy;
    string? policy_document_json;
    string ministry;
    string? department;
    string? issuing_authority;
    string? status;
    string? policy_type;
    string? priority_level;
    time:Utc? effective_date;
    time:Utc? expiry_date;
    string? implementation_status;
    string? legal_reference;
    string? parent_legislation;
    string? affected_sectors_json;
    boolean? public_consultation_required;
    time:Utc? consultation_start_date;
    time:Utc? consultation_end_date;
    string? tags_json;
    string? metadata_json;
|};
