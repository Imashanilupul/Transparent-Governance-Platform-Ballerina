# Type definitions for the Transparent Governance Platform

# User-related types
public type User record {
    # Unique identifier for the user
    string id;
    # User's email address
    string email;
    # User's full name
    string name;
    # User's role in the system
    string role;
    # Timestamp when the user was created
    string createdAt;
    # Timestamp when the user was last updated
    string updatedAt;
};

public enum UserRole {
    ADMIN = "admin",
    MINISTRY = "ministry", 
    PROVINCIAL = "provincial",
    CITIZEN = "citizen",
    SYSTEM_ADMIN = "system_admin",
    TREASURY = "treasury",
    OVERSIGHT = "oversight"
}

# Authentication types
public type LoginRequest record {
    # User's email address for login
    string email;
    # User's password for authentication
    string password;
};

public type RegisterRequest record {
    # User's email address for registration
    string email;
    # User's password for authentication
    string password;
    # User's full name
    string name;
    # Optional role assignment for the user
    string role?;
};

public type LoginResponse record {
    # Indicates if the login was successful
    boolean success;
    # Response message
    string message;
    # Login data containing token and user information
    LoginData data;
};

public type LoginData record {
    # Authentication token
    string token;
    # User information
    User user;
};

# Voting-related types
public type VotingProposal record {
    # Unique identifier for the proposal
    string id;
    # Title of the proposal
    string title;
    # Detailed description of the proposal
    string description;
    # Category classification of the proposal
    string category;
    # Total number of votes cast
    int totalVotes;
    # Number of yes votes
    int yesVotes;
    # Number of no votes
    int noVotes;
    # Current status of the proposal
    string status;
    # Time remaining for voting
    string timeRemaining;
    # Required number of votes for validity
    int requiredVotes;
    # Blockchain hash for verification
    string blockchainHash;
    # Verification status on blockchain
    string verificationStatus;
    # Timestamp when the proposal was created
    string createdAt;
    # End date for voting period
    string endDate;
};

public type CreateProposalRequest record {
    # Title of the new proposal
    string title;
    # Detailed description of the proposal
    string description;
    # Category classification of the proposal
    string category;
    # End date for the voting period
    string endDate;
    # Required number of votes for validity
    int requiredVotes;
};

public type VoteRequest record {
    # Vote choice ("yes" or "no")
    string vote; # "yes" or "no"
    # ID of the user casting the vote
    string userId;
};

public enum ProposalStatus {
    ACTIVE = "active",
    PASSED = "passed", 
    FAILED = "failed",
    PENDING = "pending"
}

public enum VerificationStatus {
    VERIFIED = "verified",
    PENDING = "pending",
    FAILED = "failed"
}

# Spending-related types
public type SpendingProject record {
    # Unique identifier for the project
    string id;
    # Name of the spending project
    string name;
    # Category classification of the project
    string category;
    # Total budget allocated for the project
    decimal budget;
    # Amount already spent on the project
    decimal spent;
    # Completion progress percentage
    int progress;
    # Current status of the project
    string status;
    # Contractor responsible for the project
    string contractor;
    # Location where the project is being executed
    string location;
    # Blockchain hash for verification
    string blockchainHash;
    # Timestamp of the last update
    string lastUpdate;
    # Timestamp when the project was created
    string createdAt;
    # Timestamp when the project was last updated
    string updatedAt;
};

public type CreateSpendingProjectRequest record {
    # Name of the new spending project
    string name;
    # Category classification of the project
    string category;
    # Total budget for the project
    decimal budget;
    # Contractor responsible for the project
    string contractor;
    # Location where the project will be executed
    string location;
};

public enum ProjectStatus {
    IN_PROGRESS = "In Progress",
    COMPLETED = "Completed",
    NEAR_COMPLETION = "Near Completion", 
    DELAYED = "Delayed",
    CANCELLED = "Cancelled"
}

# Blockchain-related types
public type BlockchainBlock record {
    # Block height in the blockchain
    int height;
    # Hash of the block
    string hash;
    # Number of transactions in the block
    int transactions;
    # Timestamp when the block was created
    string timestamp;
    # Validator who validated the block
    string validator;
    # Status of the block
    string status;
};

public enum BlockStatus {
    CONFIRMED = "confirmed",
    PENDING = "pending",
    FAILED = "failed"
}

# API Response types
public type ApiResponse record {
    # Indicates if the operation was successful
    boolean success;
    # Response message
    string message;
    # Optional response data
    json data?;
};

public type UserResponse record {
    # Indicates if the operation was successful
    boolean success;
    # User data
    User data;
};

public type VotingProposalsResponse record {
    # Indicates if the operation was successful
    boolean success;
    # Array of voting proposals
    VotingProposal[] data;
};

public type SpendingProjectsResponse record {
    # Indicates if the operation was successful
    boolean success;
    # Array of spending projects
    SpendingProject[] data;
};

public type BlockchainResponse record {
    # Indicates if the operation was successful
    boolean success;
    # Array of blockchain blocks
    BlockchainBlock[] data;
};

public type PaginatedResponse record {
    # Array of response data
    json[] data;
    # Total number of items
    int total;
    # Current page number
    int page;
    # Number of items per page
    int 'limit;
    # Total number of pages
    int totalPages;
};
