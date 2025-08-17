#!/usr/bin/env powershell

# Start Auth Service for Transparent Governance Platform
# This script starts the Web3 + JWT authentication service

Write-Host "🚀 Starting Web3 Authentication Service..." -ForegroundColor Green
Write-Host "📍 Location: auth-service" -ForegroundColor Yellow
Write-Host "🌐 Port: 3001" -ForegroundColor Yellow
Write-Host ""

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "⚠️  Warning: .env file not found!" -ForegroundColor Red
    Write-Host "📋 Please copy .env.example to .env and configure your values" -ForegroundColor Yellow
    Write-Host ""
    
    # Ask if user wants to continue anyway
    $continue = Read-Host "Continue anyway? (y/N)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        Write-Host "❌ Exiting..." -ForegroundColor Red
        exit 1
    }
}

# Check if node_modules exists
if (-not (Test-Path "node_modules")) {
    Write-Host "📦 Installing dependencies..." -ForegroundColor Blue
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
        exit 1
    }
}

Write-Host "🔧 Starting in development mode..." -ForegroundColor Blue
Write-Host "🌍 Environment: Development" -ForegroundColor Yellow
Write-Host "🔗 Health Check: http://localhost:3001/health" -ForegroundColor Cyan
Write-Host "🔐 Auth Endpoints: http://localhost:3001/auth/*" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
Write-Host "----------------------------------------" -ForegroundColor Gray

# Start the server
npm run dev
