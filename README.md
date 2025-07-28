# Transparent Governance Platform

A comprehensive civic transparency and governance platform built with **Ballerina** backend and **Next.js 15** frontend.

## 🏗️ Architecture

This platform uses a modern microservices architecture:

- **Backend**: Ballerina programming language - designed for integration and cloud-native development
- **Frontend**: Next.js 15 with React 19 - modern, responsive user interface
- **Database**: MongoDB - flexible document storage for governance data
- **Blockchain**: Integration ready for transparent transaction tracking

## ✨ Features

- 🏛️ **Government Administration Portal** - Multiple dashboard types for different government levels
- 📊 **Spending Tracker** - Monitor government expenditures and budget allocation
- 🗳️ **Voting System** - Secure digital voting platform with blockchain verification
- 📝 **Policy Hub** - Policy management and public engagement
- 🔍 **Whistleblowing System** - Anonymous reporting system
- ⛓️ **Blockchain Integration** - Transparent transaction tracking and verification
- 📱 **Responsive Design** - Mobile-first approach with modern UI
- 🔐 **Secure Authentication** - JWT-based authentication and authorization
- 🌍 **Cloud Native** - Built for scalability and integration

## 🛠️ Tech Stack

### Backend (Ballerina)
- **Language**: Ballerina 2201.12.7
- **Database**: MongoDB integration ready
- **Authentication**: JWT tokens
- **API**: RESTful services with built-in CORS
- **Logging**: Structured logging with Ballerina log module

### Frontend (Next.js)
- **Framework**: Next.js 15.2.4
- **Frontend**: React 19
- **Styling**: Tailwind CSS
- **UI Components**: Radix UI primitives
- **Form Handling**: React Hook Form with Zod validation
- **Charts**: Recharts
- **Icons**: Lucide React
- **Theme**: Next Themes (Dark/Light mode)

## 🚀 Getting Started

### Prerequisites

- **Node.js** 18+ (for frontend)
- **Ballerina** 2201.12.7+ ([Download here](https://ballerina.io/downloads/))
- **Java** 11+ (required by Ballerina)
- **MongoDB** (for database)
- **pnpm** (recommended) or npm

### Quick Setup

#### Option 1: Automated Setup

**Windows:**
```batch
setup.bat
```

**Linux/macOS:**
```bash
chmod +x setup.sh
./setup.sh
```

#### Option 2: Manual Setup

1. **Clone the repository:**
```bash
git clone <your-repo-url>
cd transparent-governance-platform
```

2. **Install dependencies:**
```bash
# Install root dependencies
npm install

# Install client dependencies
cd client && npm install && cd ..

# Install shared dependencies  
cd shared && npm install && cd ..
```

3. **Build the Ballerina backend:**
```bash
cd server
bal build
cd ..
```

4. **Start the development environment:**
```bash
# Start both frontend and backend
npm run dev

# Or start individually
npm run dev:client  # Frontend only
npm run dev:server  # Backend only
```

### 🌐 Access Points

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:9090/api
- **Health Check**: http://localhost:9090/api/health

4. Open [http://localhost:3000](http://localhost:3000) in your browser.

## Available Scripts

- `pnpm dev` - Start development server
- `pnpm build` - Build for production
- `pnpm start` - Start production server
- `pnpm lint` - Run ESLint

## Project Structure

```
civic-blockchain-platform/
├── app/                          # Next.js App Router
│   ├── admin/                   # Government admin pages
│   ├── globals.css              # Global styles
│   ├── layout.tsx               # Root layout
│   └── page.tsx                 # Home page
├── components/                   # React components
│   ├── admin/                   # Admin dashboard components
│   │   ├── admin-dashboard.tsx
│   │   ├── ministry-dashboard.tsx
│   │   ├── oversight-dashboard.tsx
│   │   ├── provincial-dashboard.tsx
│   │   ├── system-admin-dashboard.tsx
│   │   └── treasury-dashboard.tsx
│   ├── ui/                      # Reusable UI components
│   ├── blockchain-visualization.tsx
│   ├── policy-hub.tsx
│   ├── spending-tracker.tsx
│   ├── voting-system.tsx
│   └── whistleblowing-system.tsx
├── hooks/                       # Custom React hooks
├── lib/                         # Utility functions
└── public/                      # Static assets
```

## Government Administration Features

The platform includes specialized dashboards for different levels of government:

- **System Admin Dashboard** - Overall system management
- **Ministry Dashboard** - Department-specific administration
- **Treasury Dashboard** - Financial oversight and budget management
- **Provincial Dashboard** - Regional government administration
- **Oversight Dashboard** - Compliance and monitoring

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
