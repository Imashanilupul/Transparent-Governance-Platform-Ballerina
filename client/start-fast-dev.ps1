# Fast Development Start Script
# This script optimizes Node.js and Next.js for faster development

Write-Host "🚀 Starting Fast Development Mode..." -ForegroundColor Green

# Set Node.js optimizations
$env:NODE_OPTIONS = "--max-old-space-size=8192 --experimental-loader ts-node/esm"
$env:NEXT_TELEMETRY_DISABLED = "1"
$env:NODE_ENV = "development"

# Clear Next.js cache for fresh start
Write-Host "🧹 Clearing Next.js cache..." -ForegroundColor Yellow
if (Test-Path ".next") {
    Remove-Item -Recurse -Force ".next"
}

# Start with Turbo (experimental fast bundler)
Write-Host "🔥 Starting Next.js with Turbo..." -ForegroundColor Cyan
npm run dev:fast
