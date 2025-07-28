import ballerina/http;
import ballerina/log;
import ballerina/time;

# Server configuration  
configurable int serverPort = 9090;
configurable string allowedOrigin = "http://localhost:3000";

# CORS configuration
@http:ServiceConfig {
    cors: {
        allowOrigins: [allowedOrigin],
        allowCredentials: true,
        allowHeaders: ["Content-Type", "Authorization"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    }
}
service /api on new http:Listener(serverPort) {
    
    # Health check endpoint
    resource function get health() returns json {
        return {
            "status": "OK",
            "timestamp": time:utcNow().toString(),
            "service": "Transparent Governance Platform - Ballerina Backend"
        };
    }

    # Auth endpoints
    resource function post auth/login(@http:Payload LoginRequest payload) returns LoginResponse|error {
        // TODO: Implement authentication logic with MongoDB
        log:printInfo("Login request received for: " + payload.email);
        
        User user = check getUserByEmail(payload.email);
        
        LoginData data = {
            token: "mock-jwt-token",
            user: user
        };
        
        LoginResponse response = {
            success: true,
            message: "Login successful",
            data: data
        };
        
        return response;
    }

    resource function post auth/register(@http:Payload RegisterRequest payload) returns ApiResponse|error {
        // TODO: Implement registration logic with MongoDB
        log:printInfo("Registration request received for: " + payload.email);
        
        User newUser = {
            id: "generated-id", 
            email: payload.email,
            name: payload.name,
            role: payload.role ?: "citizen",
            createdAt: time:utcNow().toString(),
            updatedAt: time:utcNow().toString()
        };
        
        string userId = check createUser(newUser);
        
        ApiResponse response = {
            success: true,
            message: "Registration successful",
            data: {"userId": userId}
        };
        
        return response;
    }

    # User endpoints
    resource function get users/[string userId]() returns UserResponse|error {
        // Get user from database
        log:printInfo("Get user request for ID: " + userId);
        
        User user = check getUserById(userId);
        
        UserResponse response = {
            success: true,
            data: user
        };
        
        return response;
    }

    # Voting endpoints
    resource function get voting/proposals() returns VotingProposalsResponse|error {
        // Get all proposals from database
        log:printInfo("Get voting proposals request");
        
        VotingProposal[] proposals = check getAllProposals();
        
        VotingProposalsResponse response = {
            success: true,
            data: proposals
        };
        
        return response;
    }

    resource function post voting/proposals(@http:Payload CreateProposalRequest payload) returns ApiResponse|error {
        // Create new proposal in database with blockchain integration
        log:printInfo("Create proposal request: " + payload.title);
        
        VotingProposal newProposal = {
            id: "generated-proposal-id",
            title: payload.title,
            description: payload.description,
            category: payload.category,
            totalVotes: 0,
            yesVotes: 0,
            noVotes: 0,
            status: "active",
            timeRemaining: "30 days",
            requiredVotes: payload.requiredVotes,
            blockchainHash: "pending",
            verificationStatus: "pending", 
            createdAt: time:utcNow().toString(),
            endDate: payload.endDate
        };
        
        string proposalId = check createProposal(newProposal);
        
        ApiResponse response = {
            success: true,
            message: "Proposal created successfully",
            data: {"proposalId": proposalId}
        };
        
        return response;
    }

    resource function post voting/proposals/[string proposalId]/vote(@http:Payload VoteRequest payload) returns ApiResponse|error {
        // Record vote with MongoDB and blockchain integration
        log:printInfo("Vote request for proposal: " + proposalId + " by user: " + payload.userId);
        
        boolean voteRecorded = check recordVote(proposalId, payload.userId, payload.vote);
        
        ApiResponse response = {
            success: voteRecorded,
            message: voteRecorded ? "Vote recorded successfully" : "Failed to record vote"
        };
        
        return response;
    }

    # Spending endpoints
    resource function get spending/projects() returns SpendingProjectsResponse|error {
        // Get all spending projects from database
        log:printInfo("Get spending projects request");
        
        SpendingProject[] projects = check getAllSpendingProjects();
        
        SpendingProjectsResponse response = {
            success: true,
            data: projects
        };
        
        return response;
    }

    resource function post spending/projects(@http:Payload CreateSpendingProjectRequest payload) returns ApiResponse|error {
        // Create new spending project in database
        log:printInfo("Create spending project request: " + payload.name);
        
        SpendingProject newProject = {
            id: "generated-project-id",
            name: payload.name,
            category: payload.category,
            budget: payload.budget,
            spent: 0.0,
            progress: 0,
            status: "In Progress", 
            contractor: payload.contractor,
            location: payload.location,
            blockchainHash: "pending",
            lastUpdate: time:utcNow().toString(),
            createdAt: time:utcNow().toString(),
            updatedAt: time:utcNow().toString()
        };
        
        string projectId = check createSpendingProject(newProject);
        
        ApiResponse response = {
            success: true,
            message: "Spending project created successfully",
            data: {"projectId": projectId}
        };
        
        return response;
    }

    # Blockchain endpoints
    resource function get blockchain/blocks() returns BlockchainResponse|error {
        // Get blockchain blocks
        log:printInfo("Get blockchain blocks request");
        
        BlockchainBlock[] blocks = check getAllBlocks();
        
        BlockchainResponse response = {
            success: true,
            data: blocks
        };
        
        return response;
    }
}

public function main() returns error? {
    log:printInfo("Starting Transparent Governance Platform - Ballerina Backend");
    log:printInfo("Server running on port: " + serverPort.toString());
}
