import { apiService } from './api'

export interface AdminRole {
  id: number
  role_name: string
  institution: string
  description?: string
  permissions: string[]
  ministry_level?: string
  is_active: boolean
  created_at: string
  updated_at: string
}

export interface Admin {
  id: number
  user_name: string
  email: string
  full_name?: string
  phone?: string
  department?: string
  role_id: number
  admin_roles?: AdminRole
  is_active: boolean
  last_login?: string
  created_at: string
  updated_at: string
}

export interface CreateAdminRoleRequest {
  role_name: string
  institution: string
  description?: string
  permissions: string[]
  ministry_level?: string
}

export interface CreateAdminRequest {
  user_name: string
  email: string
  full_name?: string
  phone?: string
  department?: string
  role_id: number
}

export interface UpdateAdminRequest {
  user_name?: string
  email?: string
  full_name?: string
  phone?: string
  department?: string
  role_id?: number
  is_active?: boolean
}

export interface AdminAuthRequest {
  email: string
}

export interface AdminAuthResponse {
  success: boolean
  message: string
  data?: Admin
  timestamp: number
}

export interface AdminPermissionCheck {
  success: boolean
  hasPermission: boolean
  permissions?: string[]
  message?: string
  timestamp: number
}

// Predefined role permissions for different government institutions
export const ROLE_PERMISSIONS = {
  // Super Admin permissions
  SUPER_ADMIN: [
    'manage_admins',
    'manage_roles',
    'view_all_data',
    'manage_system',
    'assign_reports',
    'assign_petitions'
  ],
  
  // Ministry of Finance permissions
  MINISTRY_OF_FINANCE: [
    'view_budget_data',
    'manage_categories',
    'manage_projects',
    'view_financial_reports',
    'approve_transactions',
    'view_finance_petitions'
  ],
  
  // Parliament permissions
  PARLIAMENT: [
    'view_proposals',
    'manage_proposals',
    'view_policies',
    'manage_policies',
    'view_petitions',
    'respond_to_petitions',
    'view_reports'
  ],
  
  // Central Bank permissions
  CENTRAL_BANK: [
    'view_monetary_data',
    'view_financial_reports',
    'manage_monetary_policies',
    'view_banking_reports'
  ],
  
  // Anti-Corruption Commission permissions
  ANTI_CORRUPTION: [
    'view_reports',
    'investigate_reports',
    'manage_corruption_cases',
    'view_whistleblowing_data'
  ],
  
  // Provincial Council permissions
  PROVINCIAL_COUNCIL: [
    'view_provincial_data',
    'manage_provincial_projects',
    'view_provincial_reports',
    'view_provincial_petitions'
  ],
  
  // Ministry of Health permissions
  MINISTRY_OF_HEALTH: [
    'view_health_data',
    'manage_health_projects',
    'view_health_reports',
    'manage_health_policies'
  ],
  
  // Ministry of Education permissions
  MINISTRY_OF_EDUCATION: [
    'view_education_data',
    'manage_education_projects',
    'view_education_reports',
    'manage_education_policies'
  ]
}

// Institution dropdown options
export const INSTITUTIONS = [
  'Ministry of Finance',
  'Parliament of Sri Lanka',
  'Central Bank of Sri Lanka',
  'Commission to Investigate Allegations of Bribery or Corruption',
  'Provincial Council - Western',
  'Provincial Council - Central',
  'Provincial Council - Southern',
  'Provincial Council - Northern',
  'Provincial Council - Eastern',
  'Provincial Council - North Western',
  'Provincial Council - North Central',
  'Provincial Council - Uva',
  'Provincial Council - Sabaragamuwa',
  'Ministry of Health',
  'Ministry of Education',
  'Ministry of Defense',
  'Ministry of Transport',
  'Ministry of Agriculture',
  'Ministry of Environment',
  'Ministry of Tourism',
  'Auditor General\'s Department',
  'Department of Census and Statistics',
  'Custom'
]

export const superAdminService = {
  // Admin Roles Management
  async getAllAdminRoles(): Promise<{ success: boolean; data: AdminRole[]; message: string }> {
    try {
      const response = await apiService.get('/admin/roles')
      return response
    } catch (error) {
      console.error('Failed to get admin roles:', error)
      return {
        success: false,
        data: [],
        message: 'Failed to fetch admin roles'
      }
    }
  },

  async createAdminRole(roleData: CreateAdminRoleRequest): Promise<{ success: boolean; data?: AdminRole; message: string }> {
    try {
      const response = await apiService.post('/admin/roles', roleData)
      return response
    } catch (error) {
      console.error('Failed to create admin role:', error)
      return {
        success: false,
        message: 'Failed to create admin role'
      }
    }
  },

  // Admins Management
  async getAllAdmins(): Promise<{ success: boolean; data: Admin[]; message: string }> {
    try {
      const response = await apiService.get('/admin/admins')
      return response
    } catch (error) {
      console.error('Failed to get admins:', error)
      return {
        success: false,
        data: [],
        message: 'Failed to fetch admins'
      }
    }
  },

  async createAdmin(adminData: CreateAdminRequest): Promise<{ success: boolean; data?: Admin; message: string }> {
    try {
      const response = await apiService.post('/admin/admins', adminData)
      return response
    } catch (error) {
      console.error('Failed to create admin:', error)
      return {
        success: false,
        message: 'Failed to create admin'
      }
    }
  },

  async updateAdmin(adminId: number, updateData: UpdateAdminRequest): Promise<{ success: boolean; data?: Admin; message: string }> {
    try {
      const response = await apiService.put(`/admin/admins/${adminId}`, updateData)
      return response
    } catch (error) {
      console.error('Failed to update admin:', error)
      return {
        success: false,
        message: 'Failed to update admin'
      }
    }
  },

  async deleteAdmin(adminId: number): Promise<{ success: boolean; message: string }> {
    try {
      const response = await apiService.delete(`/admin/admins/${adminId}`)
      return response
    } catch (error) {
      console.error('Failed to delete admin:', error)
      return {
        success: false,
        message: 'Failed to delete admin'
      }
    }
  },

  // Authentication
  async authenticateAdmin(email: string): Promise<AdminAuthResponse> {
    try {
      const response = await apiService.post('/admin/authenticate', { email })
      return response
    } catch (error) {
      console.error('Failed to authenticate admin:', error)
      return {
        success: false,
        message: 'Failed to authenticate admin',
        timestamp: Date.now()
      }
    }
  },

  // Permission Management
  async checkAdminPermission(adminId: number, permission: string): Promise<AdminPermissionCheck> {
    try {
      const response = await apiService.get(`/admin/admins/${adminId}/permissions/${permission}`)
      return response
    } catch (error) {
      console.error('Failed to check admin permission:', error)
      return {
        success: false,
        hasPermission: false,
        message: 'Failed to check permission',
        timestamp: Date.now()
      }
    }
  },

  async getAdminsByRole(roleId: number): Promise<{ success: boolean; data: Admin[]; message: string }> {
    try {
      const response = await apiService.get(`/admin/roles/${roleId}/admins`)
      return response
    } catch (error) {
      console.error('Failed to get admins by role:', error)
      return {
        success: false,
        data: [],
        message: 'Failed to fetch admins by role'
      }
    }
  },

  // Helper functions
  getPermissionsForInstitution(institution: string): string[] {
    const institutionKey = institution.toUpperCase().replace(/[^A-Z]/g, '_')
    return ROLE_PERMISSIONS[institutionKey as keyof typeof ROLE_PERMISSIONS] || []
  },

  getDefaultRoleForInstitution(institution: string): string {
    if (institution.includes('Ministry of Finance')) return 'Finance Admin'
    if (institution.includes('Parliament')) return 'Parliamentary Admin'
    if (institution.includes('Central Bank')) return 'Banking Admin'
    if (institution.includes('Provincial Council')) return 'Provincial Admin'
    if (institution.includes('Corruption')) return 'Anti-Corruption Admin'
    if (institution.includes('Ministry of Health')) return 'Health Admin'
    if (institution.includes('Ministry of Education')) return 'Education Admin'
    return 'Government Admin'
  }
}

// Enhanced admin service with role-based filtering
export const enhancedAdminService = {
  ...superAdminService,

  // Get filtered data based on admin role permissions
  async getFilteredData(adminId: number, dataType: string) {
    try {
      // Check permissions first
      const permissionCheck = await this.checkAdminPermission(adminId, `view_${dataType}`)
      
      if (!permissionCheck.hasPermission) {
        return {
          success: false,
          data: [],
          message: 'Insufficient permissions to view this data'
        }
      }

      // Fetch data based on permissions
      switch (dataType) {
        case 'budget_data':
          return await apiService.get('/categories')
        case 'proposals':
          return await apiService.get('/proposals')
        case 'policies':
          return await apiService.get('/policies')
        case 'reports':
          return await apiService.get('/reports')
        case 'petitions':
          return await apiService.get('/petitions')
        default:
          return {
            success: false,
            data: [],
            message: 'Unknown data type'
          }
      }
    } catch (error) {
      console.error('Failed to get filtered data:', error)
      return {
        success: false,
        data: [],
        message: 'Failed to fetch data'
      }
    }
  }
}
