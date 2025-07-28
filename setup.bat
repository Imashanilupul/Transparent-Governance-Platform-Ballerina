@echo off
REM Setup script for Transparent Governance Platform (Windows)

echo 🚀 Setting up Transparent Governance Platform...

REM Check prerequisites
echo 📋 Checking prerequisites...

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is required but not installed. Please install Node.js first.
    exit /b 1
)

REM Check if Ballerina is installed
bal version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Ballerina is required but not installed. Please install Ballerina first.
    echo    Visit: https://ballerina.io/downloads/
    exit /b 1
)

REM Check if Java is installed
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java is required but not installed. Please install Java 11 or later.
    exit /b 1
)

echo ✅ Prerequisites check completed

REM Install root dependencies
echo 📦 Installing root dependencies...
call npm install

REM Install client dependencies
echo 📦 Installing client dependencies...
cd client
call npm install
cd ..

REM Install shared dependencies
echo 📦 Installing shared dependencies...
cd shared
call npm install
cd ..

REM Build Ballerina server
echo 🔨 Building Ballerina server...
cd server
call bal build
cd ..

echo ✅ Setup completed successfully!
echo.
echo 🎯 Next steps:
echo    1. Start the development environment:
echo       npm run dev
echo.
echo    2. Or start services individually:
echo       - Client: npm run dev:client
echo       - Server: npm run dev:server
echo.
echo    3. Access the application:
echo       - Frontend: http://localhost:3000
echo       - Backend API: http://localhost:9090/api
echo       - Health check: http://localhost:9090/api/health
echo.
echo 🔧 Configuration:
echo    - Client config: client\.env.local
echo    - Server config: server\Config.toml
echo.
echo 📚 Documentation:
echo    - Client: client\README.md
echo    - Server: server\README.md
echo    - Main: README.md

pause
