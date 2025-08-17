# Super Admin System Integration Steps

This guide provides step-by-step instructions to integrate the Super Admin system into your Transparent Governance Platform.

## 🎯 Quick Start

### Step 1: Database Setup

1. **Open Supabase Dashboard**
   - Go to your Supabase project dashboard
   - Navigate to the SQL Editor

2. **Execute Database Schema**
   - Copy and run all SQL commands from `SUPER_ADMIN_SETUP_GUIDE.md` sections:
     - Admin Roles Table
     - Admins Table  
     - Enhanced Reports Table
     - Enhanced Petitions Table
     - Report Assignments Table
     - Row Level Security policies
     - Initial Data Setup

3. **Verify Tables Created**
   ```sql
   SELECT table_name FROM information_schema.tables 
   WHERE table_schema = 'public' 
   AND table_name IN ('admin_roles', 'admins', 'report_assignments');
   ```

### Step 2: Backend Integration (Already Complete!)

✅ **Already Done**: The following backend integration is complete:
- `server/main.bal` - Admin service imported and initialized
- Admin endpoints added:
  - `GET /api/admin/roles` - List admin roles
  - `POST /api/admin/roles` - Create admin role
  - `GET /api/admin/admins` - List admins
  - `POST /api/admin/admins` - Create admin
  - `PUT /api/admin/admins/{id}` - Update admin
  - `DELETE /api/admin/admins/{id}` - Delete admin
  - `POST /api/admin/authenticate` - Admin authentication
  - `GET /api/admin/admins/{id}/permissions/{permission}` - Check permissions
  - `GET /api/admin/roles/{id}/admins` - Get admins by role

- Enhanced report creation with admin role assignment
- Enhanced petition creation with admin role assignment

### Step 3: Frontend Integration

1. **Add Super Admin Route**
   ```bash
   # Navigate to client directory
   cd client/src/app
   
   # Create super-admin directory and page
   mkdir super-admin
   ```

2. **Create Super Admin Page**
   Create `client/src/app/super-admin/page.tsx`:
   ```tsx
   import { SuperAdminPortal } from "@/components/super-admin/super-admin-portal";

   export default function SuperAdminPage() {
     return (
       <div className="container mx-auto py-6">
         <h1 className="text-3xl font-bold mb-6">Super Admin Portal</h1>
         <SuperAdminPortal />
       </div>
     );
   }
   ```

3. **Update Navigation**
   Add to your main navigation component:
   ```tsx
   import { UserCog } from "lucide-react";
   
   // In your navigation JSX
   <Link href="/super-admin" className="flex items-center gap-2 p-2 hover:bg-gray-100">
     <UserCog className="h-4 w-4" />
     Super Admin
   </Link>
   ```

4. **Update Reporting Forms**
   Replace existing whistleblowing components with:
   ```tsx
   import { EnhancedWhistleblowingSystem } from "@/components/whistleblowing/enhanced-reporting";
   
   // In your reporting page
   <EnhancedWhistleblowingSystem walletAddress={walletAddress} />
   ```

### Step 4: Environment Configuration

Add to your `client/.env.local`:
```env
# Super Admin Configuration
NEXT_PUBLIC_SUPER_ADMIN_EMAIL=superadmin@gov.lk
NEXT_PUBLIC_ENABLE_SUPER_ADMIN=true
NEXT_PUBLIC_ADMIN_SESSION_TIMEOUT=3600000
```

### Step 5: Test the System

1. **Start the Backend**
   ```bash
   cd server
   # Build the project
   bal build
   # Run the server
   bal run target/bin/main.jar
   ```

2. **Start the Frontend**
   ```bash
   cd client
   pnpm install  # Install any new dependencies
   pnpm dev
   ```

3. **Test Admin Endpoints**
   ```bash
   # Test admin roles endpoint
   curl http://localhost:8080/api/admin/roles
   
   # Test admin creation
   curl -X POST http://localhost:8080/api/admin/roles \
     -H "Content-Type: application/json" \
     -d '{"role_name":"Test Admin","institution":"Test Department","permissions":["view_reports"]}'
   ```

4. **Test Frontend Components**
   - Navigate to `/super-admin` in your browser
   - Verify the Super Admin Portal loads
   - Test role creation and management
   - Test the enhanced reporting form with admin role selection

## 🔍 Troubleshooting

### Backend Issues

**Error: Module 'admins' not found**
```bash
# Ensure the admins module is properly structured
cd server/modules/admins
ls -la  # Should show admins.bal file
```

**Error: Supabase connection failed**
- Verify your Supabase URL and service role key in `Config.toml`
- Check that all tables were created successfully
- Verify RLS policies are enabled

### Frontend Issues

**Error: Component not found**
```bash
# Ensure components are in the correct location
ls client/src/components/super-admin/
ls client/src/components/whistleblowing/
```

**Error: API endpoints not responding**
- Verify backend is running on the correct port
- Check that admin endpoints are properly registered
- Test endpoints individually with curl or Postman

### Database Issues

**Error: Table does not exist**
- Re-run the database schema creation SQL
- Verify you're connected to the correct Supabase project
- Check table permissions in Supabase dashboard

**Error: Permission denied**
- Verify RLS policies are correctly set up
- Check that the service role key has the necessary permissions
- Test queries directly in Supabase SQL editor

## 🎉 Success Checklist

- [ ] All database tables created successfully
- [ ] Backend compiles and runs without errors
- [ ] Admin endpoints respond correctly
- [ ] Frontend components load properly
- [ ] Super Admin Portal is accessible
- [ ] Enhanced reporting form works
- [ ] Admin role assignment functions properly
- [ ] Report/petition routing to admin roles works

## 📞 Next Steps

After successful integration:

1. **Create Your First Super Admin**
   - Use the SQL in the setup guide to create your initial super admin
   - Test authentication and permissions

2. **Set Up Government Institution Roles**
   - Create admin roles for each ministry/department
   - Assign appropriate permissions to each role

3. **Create Department Admins**
   - Add admins for each government institution
   - Test role-based access control

4. **Test Complete Workflow**
   - Submit a test report/petition
   - Verify it gets assigned to the correct admin role
   - Test admin dashboard functionality

5. **Production Deployment**
   - Set up environment-specific databases
   - Configure production environment variables
   - Implement backup and monitoring

The Super Admin system is now fully integrated and ready for use! 🚀
