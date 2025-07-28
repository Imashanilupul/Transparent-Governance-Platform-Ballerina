# Transparent Governance Platform - Ballerina Backend

This is the backend server for the Transparent Governance Platform, built using the Ballerina programming language.

## Features

- RESTful API endpoints for governance operations
- Authentication and user management
- Voting system for proposals
- Government spending tracking
- Blockchain integration (planned)
- MongoDB integration (planned)

## Prerequisites

- Ballerina 2201.12.7 or later
- MongoDB (for database operations)
- Java 11 or later (required by Ballerina)

## Installation

1. Ensure Ballerina is installed:
   ```bash
   bal version
   ```

2. Install dependencies:
   ```bash
   bal build
   ```

## Running the Server

1. Start the server:
   ```bash
   bal run
   ```

2. The server will start on port 9090 by default. You can verify it's running by accessing:
   ```
   http://localhost:9090/api/health
   ```

## Configuration

Configure the server by editing the `Config.toml` file:

- `serverPort`: Port number for the server (default: 9090)
- `allowedOrigin`: CORS allowed origin (default: "http://localhost:3000")
- MongoDB settings (for future implementation)
- JWT settings (for future implementation)
- Blockchain settings (for future implementation)

## API Endpoints

### Health Check
- `GET /api/health` - Server health status

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration

### Users
- `GET /api/users/{userId}` - Get user by ID

### Voting
- `GET /api/voting/proposals` - Get all voting proposals
- `POST /api/voting/proposals` - Create a new proposal
- `POST /api/voting/proposals/{proposalId}/vote` - Vote on a proposal

### Spending
- `GET /api/spending/projects` - Get all spending projects
- `POST /api/spending/projects` - Create a new spending project

### Blockchain
- `GET /api/blockchain/blocks` - Get blockchain blocks

## Development

### Project Structure

- `main.bal` - Main server file with HTTP service definitions
- `types.bal` - Type definitions for data models
- `database.bal` - Database operations (currently mock implementations)
- `Config.toml` - Configuration file
- `Ballerina.toml` - Project configuration

### Building

```bash
bal build
```

### Running in Development Mode

```bash
bal run
```

## TODO

- [ ] Implement actual MongoDB integration using `ballerinax/mongodb`
- [ ] Add JWT authentication and authorization
- [ ] Implement blockchain integration for vote verification
- [ ] Add input validation and error handling
- [ ] Add rate limiting and security features
- [ ] Add comprehensive logging
- [ ] Add unit tests
- [ ] Add API documentation
- [ ] Add Docker support

## Migration from Node.js

This Ballerina backend replaces the previous Node.js/Express backend. The API endpoints maintain compatibility with the frontend client, but the implementation has been rewritten in Ballerina for better integration capabilities and cloud-native features.

### Changes Made:

1. **Technology Stack**: Migrated from Node.js/Express to Ballerina
2. **Database**: Prepared for MongoDB integration (currently using mock data)
3. **Type Safety**: Enhanced type definitions with Ballerina's strong typing
4. **CORS**: Built-in CORS support with Ballerina HTTP service
5. **Error Handling**: Ballerina's built-in error handling patterns
6. **Configuration**: Externalized configuration using Config.toml

The API contract remains the same, so the frontend should work without modifications.
