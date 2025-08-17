# Super Admin System Database Setup Guide

This guide will help you set up the complete database schema for the enhanced Transparent Governance Platform with super admin capabilities.

## 📋 Overview

The enhanced system includes:
- **Super Admin Portal**: Manage admin roles and permissions
- **Role-Based Access Control**: Different permission levels for different government institutions
- **Intelligent Report/Petition Routing**: Automatic assignment to appropriate government authorities
- **Enhanced Admin Management**: Full CRUD operations for admins and roles

## 🗄️ Database Schema

### 1. Admin Roles Table

```sql
CREATE TABLE admin_roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL UNIQUE,
    institution VARCHAR(255) NOT NULL,
    description TEXT,
    permissions JSONB NOT NULL DEFAULT '[]',
    ministry_level VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_admin_roles_institution ON admin_roles(institution);
CREATE INDEX idx_admin_roles_active ON admin_roles(is_active);
```

### 2. Admins Table

```sql
CREATE TABLE admins (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255),
    phone VARCHAR(20),
    department VARCHAR(255),
    role_id INTEGER REFERENCES admin_roles(id) ON DELETE SET NULL,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_admins_email ON admins(email);
CREATE INDEX idx_admins_role_id ON admins(role_id);
CREATE INDEX idx_admins_active ON admins(is_active);
```

### 3. Enhanced Reports Table

```sql
-- First, check if the reports table exists and alter it
ALTER TABLE reports 
ADD COLUMN IF NOT EXISTS category VARCHAR(100),
ADD COLUMN IF NOT EXISTS target_admin_role_id INTEGER REFERENCES admin_roles(id) ON DELETE SET NULL;

-- Create index for the new columns
CREATE INDEX IF NOT EXISTS idx_reports_target_admin_role ON reports(target_admin_role_id);
CREATE INDEX IF NOT EXISTS idx_reports_category ON reports(category);

-- If the reports table doesn't exist, create it with the enhanced schema:
CREATE TABLE IF NOT EXISTS reports (
    report_id SERIAL PRIMARY KEY,
    report_title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    target_admin_role_id INTEGER REFERENCES admin_roles(id) ON DELETE SET NULL,
    priority VARCHAR(50) NOT NULL DEFAULT 'MEDIUM' 
        CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    assigned_to VARCHAR(255),
    evidence_hash VARCHAR(255) NOT NULL,
    wallet_address VARCHAR(255),
    resolved_status BOOLEAN DEFAULT false,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_time TIMESTAMP,
    CHECK (resolved_time IS NULL OR resolved_time >= created_time)
);
```

### 4. Enhanced Petitions Table

```sql
-- Alter the existing petitions table to add admin role assignment
ALTER TABLE petitions 
ADD COLUMN IF NOT EXISTS assigned_admin_role_id INTEGER REFERENCES admin_roles(id) ON DELETE SET NULL;

-- Create index for the new column
CREATE INDEX IF NOT EXISTS idx_petitions_assigned_admin_role ON petitions(assigned_admin_role_id);

-- If the petitions table doesn't exist, create it with the enhanced schema:
CREATE TABLE IF NOT EXISTS petitions (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    required_signature_count INTEGER NOT NULL,
    signature_count INTEGER DEFAULT 0,
    creator_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    assigned_admin_role_id INTEGER REFERENCES admin_roles(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deadline TIMESTAMP
);
```

### 5. Report Assignments Table

```sql
CREATE TABLE report_assignments (
    id SERIAL PRIMARY KEY,
    report_id INTEGER REFERENCES reports(report_id) ON DELETE CASCADE,
    admin_role_id INTEGER REFERENCES admin_roles(id) ON DELETE SET NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_by INTEGER REFERENCES admins(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'ASSIGNED' 
        CHECK (status IN ('ASSIGNED', 'IN_PROGRESS', 'COMPLETED', 'REJECTED')),
    notes TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_report_assignments_report_id ON report_assignments(report_id);
CREATE INDEX idx_report_assignments_admin_role_id ON report_assignments(admin_role_id);
CREATE INDEX idx_report_assignments_status ON report_assignments(status);
```

## 🔐 Row Level Security (RLS)

Enable RLS and create policies for secure access:

### Admin Roles RLS

```sql
-- Enable RLS on admin_roles table
ALTER TABLE admin_roles ENABLE ROW LEVEL SECURITY;

-- Policy for super admins to manage all roles
CREATE POLICY "Super admins can manage all roles" ON admin_roles
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM admins a
            JOIN admin_roles ar ON a.role_id = ar.id
            WHERE a.email = auth.jwt() ->> 'email'
            AND ar.permissions ? 'manage_roles'
            AND a.is_active = true
        )
    );

-- Policy for admins to view their own role
CREATE POLICY "Admins can view their own role" ON admin_roles
    FOR SELECT USING (
        id IN (
            SELECT role_id FROM admins
            WHERE email = auth.jwt() ->> 'email'
            AND is_active = true
        )
    );
```

### Admins RLS

```sql
-- Enable RLS on admins table
ALTER TABLE admins ENABLE ROW LEVEL SECURITY;

-- Policy for super admins to manage all admins
CREATE POLICY "Super admins can manage all admins" ON admins
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM admins a
            JOIN admin_roles ar ON a.role_id = ar.id
            WHERE a.email = auth.jwt() ->> 'email'
            AND ar.permissions ? 'manage_admins'
            AND a.is_active = true
        )
    );

-- Policy for admins to view and update their own profile
CREATE POLICY "Admins can manage their own profile" ON admins
    FOR ALL USING (email = auth.jwt() ->> 'email');
```

### Reports RLS

```sql
-- Enable RLS on reports table
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- Policy for admins to see reports assigned to their role
CREATE POLICY "Admins see role-assigned reports" ON reports
    FOR SELECT USING (
        target_admin_role_id IN (
            SELECT role_id FROM admins
            WHERE email = auth.jwt() ->> 'email'
            AND is_active = true
        )
        OR EXISTS (
            SELECT 1 FROM admins a
            JOIN admin_roles ar ON a.role_id = ar.id
            WHERE a.email = auth.jwt() ->> 'email'
            AND ar.permissions ? 'view_all_data'
            AND a.is_active = true
        )
    );
```

## 📊 Initial Data Setup

### 1. Create Default Admin Roles

```sql
-- Super Admin Role
INSERT INTO admin_roles (role_name, institution, description, permissions, ministry_level) VALUES
('Super Admin', 'System Administration', 'Full system access and admin management', 
 '["manage_admins", "manage_roles", "view_all_data", "manage_system", "assign_reports", "assign_petitions"]', 
 'SYSTEM');

-- Ministry of Finance
INSERT INTO admin_roles (role_name, institution, description, permissions, ministry_level) VALUES
('Finance Admin', 'Ministry of Finance', 'Manage budget, financial reports, and treasury operations', 
 '["view_budget_data", "manage_categories", "manage_projects", "view_financial_reports", "approve_transactions", "view_finance_petitions"]', 
 'MINISTRY');

-- Parliament
INSERT INTO admin_roles (role_name, institution, description, permissions, ministry_level) VALUES
('Parliamentary Admin', 'Parliament of Sri Lanka', 'Manage proposals, policies, and legislative matters', 
 '["view_proposals", "manage_proposals", "view_policies", "manage_policies", "view_petitions", "respond_to_petitions", "view_reports"]', 
 'PARLIAMENT');

-- Central Bank
INSERT INTO admin_roles (role_name, institution, description, permissions, ministry_level) VALUES
('Banking Admin', 'Central Bank of Sri Lanka', 'Manage monetary policies and banking oversight', 
 '["view_monetary_data", "view_financial_reports", "manage_monetary_policies", "view_banking_reports"]', 
 'CENTRAL_BANK');

-- Anti-Corruption Commission
INSERT INTO admin_roles (role_name, institution, description, permissions, ministry_level) VALUES
('Anti-Corruption Admin', 'Commission to Investigate Allegations of Bribery or Corruption', 'Investigate corruption reports and cases', 
 '["view_reports", "investigate_reports", "manage_corruption_cases", "view_whistleblowing_data"]', 
 'COMMISSION');

-- Provincial Councils
INSERT INTO admin_roles (role_name, institution, description, permissions, ministry_level) VALUES
('Provincial Admin - Western', 'Provincial Council - Western', 'Manage Western Province affairs', 
 '["view_provincial_data", "manage_provincial_projects", "view_provincial_reports", "view_provincial_petitions"]', 
 'PROVINCIAL'),
('Provincial Admin - Central', 'Provincial Council - Central', 'Manage Central Province affairs', 
 '["view_provincial_data", "manage_provincial_projects", "view_provincial_reports", "view_provincial_petitions"]', 
 'PROVINCIAL'),
('Provincial Admin - Southern', 'Provincial Council - Southern', 'Manage Southern Province affairs', 
 '["view_provincial_data", "manage_provincial_projects", "view_provincial_reports", "view_provincial_petitions"]', 
 'PROVINCIAL');

-- Ministry of Health
INSERT INTO admin_roles (role_name, institution, description, permissions, ministry_level) VALUES
('Health Admin', 'Ministry of Health', 'Manage health policies and health-related reports', 
 '["view_health_data", "manage_health_projects", "view_health_reports", "manage_health_policies"]', 
 'MINISTRY');

-- Ministry of Education
INSERT INTO admin_roles (role_name, institution, description, permissions, ministry_level) VALUES
('Education Admin', 'Ministry of Education', 'Manage education policies and education-related reports', 
 '["view_education_data", "manage_education_projects", "view_education_reports", "manage_education_policies"]', 
 'MINISTRY');
```

### 2. Create Default Super Admin

```sql
-- Create the first super admin (replace with actual details)
INSERT INTO admins (user_name, email, full_name, role_id, is_active) VALUES
('superadmin', 'superadmin@gov.lk', 'System Administrator', 
 (SELECT id FROM admin_roles WHERE role_name = 'Super Admin'), true);
```

## 🚀 API Integration

### Backend Updates Required

1. **Update main.bal** to include the admin service:

```ballerina
// Add to imports
import admins;

// Add to service initialization
admins:AdminsService adminsService = new (supabaseClient, port, supabaseUrl, supabaseServiceRoleKey);

// Add admin endpoints
resource function get admin/roles() returns json|error {
    return adminsService.getAllAdminRoles();
}

resource function post admin/roles(http:Request request) returns json|error {
    json payload = check request.getJsonPayload();
    return adminsService.createAdminRole(payload);
}

resource function get admin/admins() returns json|error {
    return adminsService.getAllAdmins();
}

resource function post admin/admins(http:Request request) returns json|error {
    json payload = check request.getJsonPayload();
    return adminsService.createAdmin(payload);
}

resource function put admin/admins/[string id](http:Request request) returns json|error {
    int adminId = check int:fromString(id);
    json payload = check request.getJsonPayload();
    return adminsService.updateAdmin(adminId, payload);
}

resource function delete admin/admins/[string id]() returns json|error {
    int adminId = check int:fromString(id);
    return adminsService.deleteAdmin(adminId);
}

resource function post admin/authenticate(http:Request request) returns json|error {
    json payload = check request.getJsonPayload();
    string email = check payload.email;
    return adminsService.authenticateAdmin(email);
}

resource function get admin/admins/[string id]/permissions/[string permission]() returns json|error {
    int adminId = check int:fromString(id);
    return adminsService.checkAdminPermission(adminId, permission);
}
```

2. **Update report and petition creation endpoints** to accept admin role assignments:

```ballerina
// In reports endpoint
resource function post reports(http:Request request) returns json|error {
    json payload = check request.getJsonPayload();
    string title = check payload.report_title;
    string evidenceHash = check payload.evidence_hash;
    string? description = payload.description is string ? <string>payload.description : ();
    string? category = payload.category is string ? <string>payload.category : ();
    string priority = payload.priority is string ? <string>payload.priority : "MEDIUM";
    int? targetAdminRoleId = payload.target_admin_role_id is int ? <int>payload.target_admin_role_id : ();
    int? userId = payload.user_id is int ? <int>payload.user_id : ();
    string? walletAddress = payload.wallet_address is string ? <string>payload.wallet_address : ();
    
    return reportsService.createReport(title, evidenceHash, description, category, priority, (), targetAdminRoleId, userId, walletAddress);
}

// In petitions endpoint
resource function post petitions(http:Request request) returns json|error {
    json payload = check request.getJsonPayload();
    string title = check payload.title;
    string description = check payload.description;
    int requiredSignatureCount = check payload.required_signature_count;
    int? creatorId = payload.creator_id is int ? <int>payload.creator_id : ();
    int? assignedAdminRoleId = payload.assigned_admin_role_id is int ? <int>payload.assigned_admin_role_id : ();
    string? deadline = payload.deadline is string ? <string>payload.deadline : ();
    
    return petitionsService.createPetition(title, description, requiredSignatureCount, creatorId, assignedAdminRoleId, deadline);
}
```

## 🎯 Frontend Integration

### 1. Navigation Updates

Add the Super Admin Portal to your navigation:

```tsx
// In your main navigation component
import Link from "next/link"

<Link href="/super-admin" className="nav-link">
    <UserCog className="h-4 w-4" />
    Super Admin
</Link>
```

### 2. Enhanced Reporting Components

Replace the existing whistleblowing component with the enhanced version:

```tsx
// In your main reporting page
import { EnhancedWhistleblowingSystem } from "@/components/whistleblowing/enhanced-reporting"

export default function ReportingPage() {
  return <EnhancedWhistleblowingSystem walletAddress={walletAddress} />
}
```

## 🔧 Configuration

### Environment Variables

Add to your `.env.local`:

```env
# Super Admin Configuration
NEXT_PUBLIC_SUPER_ADMIN_EMAIL=superadmin@gov.lk
NEXT_PUBLIC_ENABLE_SUPER_ADMIN=true

# Admin Portal Settings
NEXT_PUBLIC_ADMIN_SESSION_TIMEOUT=3600000
NEXT_PUBLIC_REQUIRE_ADMIN_MFA=false
```

### Supabase Configuration

1. **Enable RLS** on all new tables
2. **Configure Authentication** for admin users
3. **Set up Email Templates** for admin invitations
4. **Configure Storage** for admin profile pictures (optional)

## 📋 Testing Checklist

### Database Setup
- [ ] All tables created successfully
- [ ] Indexes are in place
- [ ] RLS policies are active
- [ ] Foreign key relationships work
- [ ] Default admin roles inserted
- [ ] Super admin account created

### Backend API
- [ ] Admin roles CRUD operations work
- [ ] Admins CRUD operations work
- [ ] Authentication endpoint works
- [ ] Permission checking works
- [ ] Report creation with admin role assignment
- [ ] Petition creation with admin role assignment

### Frontend
- [ ] Super Admin Portal loads correctly
- [ ] Role management interface works
- [ ] Admin management interface works
- [ ] Enhanced reporting form works
- [ ] Admin role dropdown populates
- [ ] Permission-based UI elements show/hide correctly

### Integration
- [ ] Reports are correctly assigned to admin roles
- [ ] Petitions are correctly assigned to admin roles
- [ ] Admin authentication flow works
- [ ] Role-based data filtering works
- [ ] Super admin can manage all admins and roles

## 🚨 Security Considerations

1. **Environment Separation**: Use different databases for development, staging, and production
2. **API Keys**: Never expose service role keys in frontend code
3. **Authentication**: Implement proper admin authentication with MFA
4. **Audit Logging**: Log all admin actions for accountability
5. **Data Encryption**: Ensure sensitive data is encrypted at rest and in transit
6. **Regular Backups**: Implement automated database backups
7. **Access Reviews**: Regularly review admin permissions and access

## 📞 Support

If you encounter issues during setup:

1. Check the browser console for frontend errors
2. Check the Ballerina server logs for backend errors
3. Verify database connections and permissions
4. Ensure all environment variables are set correctly
5. Test API endpoints individually using a tool like Postman

## 🎉 Next Steps

After successful setup:

1. **Create Additional Admin Roles** for specific departments
2. **Implement Email Notifications** for report/petition assignments
3. **Add Dashboard Analytics** for admin performance
4. **Implement Audit Logging** for all admin actions
5. **Set up Monitoring** for system health and performance
6. **Create Admin Training Materials** for new users

This enhanced system provides a robust foundation for managing government transparency with proper role-based access control and intelligent routing of citizen reports and petitions.
