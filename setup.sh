#!/bin/bash

# Setup script for Transparent Governance Platform

echo "🚀 Setting up Transparent Governance Platform..."

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required but not installed. Please install Node.js first."
    exit 1
fi

# Check if Ballerina is installed
if ! command -v bal &> /dev/null; then
    echo "❌ Ballerina is required but not installed. Please install Ballerina first."
    echo "   Visit: https://ballerina.io/downloads/"
    exit 1
fi

# Check if Java is installed (required for Ballerina)
if ! command -v java &> /dev/null; then
    echo "❌ Java is required but not installed. Please install Java 11 or later."
    exit 1
fi

echo "✅ Prerequisites check completed"

# Install root dependencies
echo "📦 Installing root dependencies..."
npm install

# Install client dependencies
echo "📦 Installing client dependencies..."
cd client
npm install
cd ..

# Install shared dependencies
echo "📦 Installing shared dependencies..."
cd shared
npm install
cd ..

# Build Ballerina server
echo "🔨 Building Ballerina server..."
cd server
bal build
cd ..

echo "✅ Setup completed successfully!"
echo ""
echo "🎯 Next steps:"
echo "   1. Start the development environment:"
echo "      npm run dev"
echo ""
echo "   2. Or start services individually:"
echo "      - Client: npm run dev:client"
echo "      - Server: npm run dev:server"
echo ""
echo "   3. Access the application:"
echo "      - Frontend: http://localhost:3000"
echo "      - Backend API: http://localhost:9090/api"
echo "      - Health check: http://localhost:9090/api/health"
echo ""
echo "🔧 Configuration:"
echo "   - Client config: client/.env.local"
echo "   - Server config: server/Config.toml"
echo ""
echo "📚 Documentation:"
echo "   - Client: client/README.md"
echo "   - Server: server/README.md"
echo "   - Main: README.md"
