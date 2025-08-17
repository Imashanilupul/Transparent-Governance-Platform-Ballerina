"use client"

import { useState, useEffect } from "react"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { Badge } from "@/components/ui/badge"
import { useToast } from "@/hooks/use-toast"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import {
  UserCog,
  Shield,
  Users,
  Settings,
  Plus,
  Edit,
  Trash2,
  Eye,
  UserCheck,
  Building,
  Calendar,
  AlertTriangle,
  CheckCircle,
  Clock,
  Mail,
  Phone,
  MapPin
} from "lucide-react"
import { 
  superAdminService, 
  enhancedAdminService,
  INSTITUTIONS, 
  ROLE_PERMISSIONS,
  type AdminRole, 
  type Admin,
  type CreateAdminRoleRequest,
  type CreateAdminRequest,
  type UpdateAdminRequest
} from "@/services/super-admin"

export function SuperAdminPortal() {
  const { toast } = useToast()
  const [activeTab, setActiveTab] = useState("overview")
  
  // State for admin roles
  const [adminRoles, setAdminRoles] = useState<AdminRole[]>([])
  const [admins, setAdmins] = useState<Admin[]>([])
  const [loading, setLoading] = useState(true)
  
  // Form states
  const [roleFormData, setRoleFormData] = useState<CreateAdminRoleRequest>({
    role_name: "",
    institution: "",
    description: "",
    permissions: []
  })
  const [adminFormData, setAdminFormData] = useState<CreateAdminRequest>({
    user_name: "",
    email: "",
    full_name: "",
    phone: "",
    department: "",
    role_id: 0
  })
  
  // Dialog states
  const [isRoleDialogOpen, setIsRoleDialogOpen] = useState(false)
  const [isAdminDialogOpen, setIsAdminDialogOpen] = useState(false)
  const [editingRole, setEditingRole] = useState<AdminRole | null>(null)
  const [editingAdmin, setEditingAdmin] = useState<Admin | null>(null)

  useEffect(() => {
    loadInitialData()
  }, [])

  const loadInitialData = async () => {
    setLoading(true)
    try {
      const [rolesResponse, adminsResponse] = await Promise.all([
        superAdminService.getAllAdminRoles(),
        superAdminService.getAllAdmins()
      ])
      
      if (rolesResponse.success) {
        setAdminRoles(rolesResponse.data)
      }
      
      if (adminsResponse.success) {
        setAdmins(adminsResponse.data)
      }
    } catch (error) {
      console.error('Failed to load initial data:', error)
      toast({
        title: "Error",
        description: "Failed to load admin data",
        variant: "destructive"
      })
    } finally {
      setLoading(false)
    }
  }

  const handleCreateRole = async () => {
    try {
      const response = await superAdminService.createAdminRole(roleFormData)
      
      if (response.success) {
        toast({
          title: "Success",
          description: "Admin role created successfully"
        })
        setIsRoleDialogOpen(false)
        setRoleFormData({
          role_name: "",
          institution: "",
          description: "",
          permissions: []
        })
        loadInitialData()
      } else {
        toast({
          title: "Error",
          description: response.message,
          variant: "destructive"
        })
      }
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to create admin role",
        variant: "destructive"
      })
    }
  }

  const handleCreateAdmin = async () => {
    try {
      const response = await superAdminService.createAdmin(adminFormData)
      
      if (response.success) {
        toast({
          title: "Success",
          description: "Admin created successfully"
        })
        setIsAdminDialogOpen(false)
        setAdminFormData({
          user_name: "",
          email: "",
          full_name: "",
          phone: "",
          department: "",
          role_id: 0
        })
        loadInitialData()
      } else {
        toast({
          title: "Error",
          description: response.message,
          variant: "destructive"
        })
      }
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to create admin",
        variant: "destructive"
      })
    }
  }

  const handleDeleteAdmin = async (adminId: number) => {
    if (!confirm("Are you sure you want to delete this admin?")) return
    
    try {
      const response = await superAdminService.deleteAdmin(adminId)
      
      if (response.success) {
        toast({
          title: "Success",
          description: "Admin deleted successfully"
        })
        loadInitialData()
      } else {
        toast({
          title: "Error",
          description: response.message,
          variant: "destructive"
        })
      }
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to delete admin",
        variant: "destructive"
      })
    }
  }

  const handleInstitutionChange = (institution: string) => {
    const permissions = superAdminService.getPermissionsForInstitution(institution)
    const defaultRoleName = superAdminService.getDefaultRoleForInstitution(institution)
    
    setRoleFormData({
      ...roleFormData,
      institution,
      role_name: defaultRoleName,
      permissions
    })
  }

  const getStatusBadge = (isActive: boolean) => {
    return (
      <Badge variant={isActive ? "default" : "secondary"}>
        {isActive ? (
          <>
            <CheckCircle className="h-3 w-3 mr-1" />
            Active
          </>
        ) : (
          <>
            <Clock className="h-3 w-3 mr-1" />
            Inactive
          </>
        )}
      </Badge>
    )
  }

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    })
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-slate-600">Loading super admin portal...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50">
      <div className="container mx-auto p-6">
        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center gap-4 mb-4">
            <div className="h-12 w-12 bg-gradient-to-br from-purple-500 to-blue-600 rounded-lg flex items-center justify-center">
              <UserCog className="h-6 w-6 text-white" />
            </div>
            <div>
              <h1 className="text-3xl font-bold text-slate-900">Super Admin Portal</h1>
              <p className="text-slate-600">Manage admin roles and permissions across government institutions</p>
            </div>
          </div>
        </div>

        <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
          <TabsList className="grid w-full grid-cols-4 lg:w-fit">
            <TabsTrigger value="overview" className="flex items-center gap-2">
              <Shield className="h-4 w-4" />
              Overview
            </TabsTrigger>
            <TabsTrigger value="roles" className="flex items-center gap-2">
              <Settings className="h-4 w-4" />
              Admin Roles
            </TabsTrigger>
            <TabsTrigger value="admins" className="flex items-center gap-2">
              <Users className="h-4 w-4" />
              Admins
            </TabsTrigger>
            <TabsTrigger value="permissions" className="flex items-center gap-2">
              <UserCheck className="h-4 w-4" />
              Permissions
            </TabsTrigger>
          </TabsList>

          <TabsContent value="overview" className="space-y-6">
            {/* Stats Cards */}
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
              <Card className="border-0 shadow-md">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">Total Admin Roles</CardTitle>
                  <Settings className="h-4 w-4 text-blue-600" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold">{adminRoles.length}</div>
                  <p className="text-xs text-slate-500">Configured institutions</p>
                </CardContent>
              </Card>

              <Card className="border-0 shadow-md">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">Active Admins</CardTitle>
                  <Users className="h-4 w-4 text-green-600" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold">
                    {admins.filter(admin => admin.is_active).length}
                  </div>
                  <p className="text-xs text-slate-500">Currently active</p>
                </CardContent>
              </Card>

              <Card className="border-0 shadow-md">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">Institutions</CardTitle>
                  <Building className="h-4 w-4 text-purple-600" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold">
                    {new Set(adminRoles.map(role => role.institution)).size}
                  </div>
                  <p className="text-xs text-slate-500">Government institutions</p>
                </CardContent>
              </Card>

              <Card className="border-0 shadow-md">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">System Health</CardTitle>
                  <CheckCircle className="h-4 w-4 text-emerald-600" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold">99.9%</div>
                  <p className="text-xs text-slate-500">Admin system uptime</p>
                </CardContent>
              </Card>
            </div>

            {/* Recent Activity */}
            <Card className="border-0 shadow-md">
              <CardHeader>
                <CardTitle>Recent Admin Activity</CardTitle>
                <CardDescription>Latest changes to admin roles and permissions</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {admins.slice(0, 5).map((admin, index) => (
                    <div key={index} className="flex items-center justify-between p-3 bg-slate-50 rounded-lg">
                      <div className="flex items-center gap-3">
                        <UserCog className="h-5 w-5 text-blue-600" />
                        <div>
                          <p className="font-medium">{admin.full_name || admin.user_name}</p>
                          <p className="text-sm text-slate-500">
                            {admin.admin_roles?.institution || 'No institution assigned'}
                          </p>
                        </div>
                      </div>
                      <div className="text-right">
                        <p className="text-sm font-medium">
                          {admin.last_login ? 'Last login' : 'Created'}
                        </p>
                        <p className="text-xs text-slate-500">
                          {formatDate(admin.last_login || admin.created_at)}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="roles" className="space-y-6">
            <div className="flex justify-between items-center">
              <div>
                <h2 className="text-2xl font-bold text-slate-900">Admin Roles Management</h2>
                <p className="text-slate-600">Configure roles and permissions for different institutions</p>
              </div>
              
              <Dialog open={isRoleDialogOpen} onOpenChange={setIsRoleDialogOpen}>
                <DialogTrigger asChild>
                  <Button className="flex items-center gap-2">
                    <Plus className="h-4 w-4" />
                    Create Role
                  </Button>
                </DialogTrigger>
                <DialogContent className="max-w-2xl">
                  <DialogHeader>
                    <DialogTitle>Create New Admin Role</DialogTitle>
                    <DialogDescription>
                      Set up a new admin role with specific permissions for a government institution
                    </DialogDescription>
                  </DialogHeader>
                  
                  <div className="grid gap-4 py-4">
                    <div className="grid grid-cols-2 gap-4">
                      <div className="space-y-2">
                        <Label htmlFor="institution">Institution</Label>
                        <Select
                          value={roleFormData.institution}
                          onValueChange={handleInstitutionChange}
                        >
                          <SelectTrigger>
                            <SelectValue placeholder="Select institution" />
                          </SelectTrigger>
                          <SelectContent>
                            {INSTITUTIONS.map((institution) => (
                              <SelectItem key={institution} value={institution}>
                                {institution}
                              </SelectItem>
                            ))}
                          </SelectContent>
                        </Select>
                      </div>
                      
                      <div className="space-y-2">
                        <Label htmlFor="role_name">Role Name</Label>
                        <Input
                          id="role_name"
                          value={roleFormData.role_name}
                          onChange={(e) => setRoleFormData({
                            ...roleFormData,
                            role_name: e.target.value
                          })}
                          placeholder="e.g., Finance Admin"
                        />
                      </div>
                    </div>
                    
                    <div className="space-y-2">
                      <Label htmlFor="description">Description</Label>
                      <Textarea
                        id="description"
                        value={roleFormData.description}
                        onChange={(e) => setRoleFormData({
                          ...roleFormData,
                          description: e.target.value
                        })}
                        placeholder="Describe the role and responsibilities..."
                        rows={3}
                      />
                    </div>
                    
                    <div className="space-y-2">
                      <Label>Permissions</Label>
                      <div className="grid grid-cols-2 gap-2 max-h-48 overflow-y-auto border rounded-md p-3">
                        {roleFormData.permissions.map((permission, index) => (
                          <Badge key={index} variant="secondary" className="justify-between">
                            {permission.replace(/_/g, ' ')}
                            <button
                              onClick={() => setRoleFormData({
                                ...roleFormData,
                                permissions: roleFormData.permissions.filter((_, i) => i !== index)
                              })}
                              className="ml-2 text-red-500 hover:text-red-700"
                            >
                              ×
                            </button>
                          </Badge>
                        ))}
                      </div>
                      <p className="text-xs text-slate-500">
                        Permissions are auto-selected based on institution. You can modify them as needed.
                      </p>
                    </div>
                  </div>
                  
                  <DialogFooter>
                    <Button variant="outline" onClick={() => setIsRoleDialogOpen(false)}>
                      Cancel
                    </Button>
                    <Button onClick={handleCreateRole}>
                      Create Role
                    </Button>
                  </DialogFooter>
                </DialogContent>
              </Dialog>
            </div>

            {/* Roles Table */}
            <Card className="border-0 shadow-md">
              <CardContent className="p-0">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Role Name</TableHead>
                      <TableHead>Institution</TableHead>
                      <TableHead>Permissions</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead>Created</TableHead>
                      <TableHead>Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {adminRoles.map((role) => (
                      <TableRow key={role.id}>
                        <TableCell className="font-medium">{role.role_name}</TableCell>
                        <TableCell>{role.institution}</TableCell>
                        <TableCell>
                          <div className="flex flex-wrap gap-1">
                            {role.permissions.slice(0, 3).map((permission, index) => (
                              <Badge key={index} variant="outline" className="text-xs">
                                {permission.replace(/_/g, ' ')}
                              </Badge>
                            ))}
                            {role.permissions.length > 3 && (
                              <Badge variant="outline" className="text-xs">
                                +{role.permissions.length - 3} more
                              </Badge>
                            )}
                          </div>
                        </TableCell>
                        <TableCell>{getStatusBadge(role.is_active)}</TableCell>
                        <TableCell>{formatDate(role.created_at)}</TableCell>
                        <TableCell>
                          <div className="flex items-center gap-2">
                            <Button variant="ghost" size="sm">
                              <Edit className="h-4 w-4" />
                            </Button>
                            <Button variant="ghost" size="sm">
                              <Eye className="h-4 w-4" />
                            </Button>
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="admins" className="space-y-6">
            <div className="flex justify-between items-center">
              <div>
                <h2 className="text-2xl font-bold text-slate-900">Admin Management</h2>
                <p className="text-slate-600">Manage individual admin accounts and their role assignments</p>
              </div>
              
              <Dialog open={isAdminDialogOpen} onOpenChange={setIsAdminDialogOpen}>
                <DialogTrigger asChild>
                  <Button className="flex items-center gap-2">
                    <Plus className="h-4 w-4" />
                    Add Admin
                  </Button>
                </DialogTrigger>
                <DialogContent className="max-w-2xl">
                  <DialogHeader>
                    <DialogTitle>Add New Admin</DialogTitle>
                    <DialogDescription>
                      Create a new admin account and assign them to a role
                    </DialogDescription>
                  </DialogHeader>
                  
                  <div className="grid gap-4 py-4">
                    <div className="grid grid-cols-2 gap-4">
                      <div className="space-y-2">
                        <Label htmlFor="user_name">Username</Label>
                        <Input
                          id="user_name"
                          value={adminFormData.user_name}
                          onChange={(e) => setAdminFormData({
                            ...adminFormData,
                            user_name: e.target.value
                          })}
                          placeholder="username"
                        />
                      </div>
                      
                      <div className="space-y-2">
                        <Label htmlFor="email">Email</Label>
                        <Input
                          id="email"
                          type="email"
                          value={adminFormData.email}
                          onChange={(e) => setAdminFormData({
                            ...adminFormData,
                            email: e.target.value
                          })}
                          placeholder="admin@example.gov.lk"
                        />
                      </div>
                    </div>
                    
                    <div className="grid grid-cols-2 gap-4">
                      <div className="space-y-2">
                        <Label htmlFor="full_name">Full Name</Label>
                        <Input
                          id="full_name"
                          value={adminFormData.full_name}
                          onChange={(e) => setAdminFormData({
                            ...adminFormData,
                            full_name: e.target.value
                          })}
                          placeholder="John Doe"
                        />
                      </div>
                      
                      <div className="space-y-2">
                        <Label htmlFor="phone">Phone</Label>
                        <Input
                          id="phone"
                          value={adminFormData.phone}
                          onChange={(e) => setAdminFormData({
                            ...adminFormData,
                            phone: e.target.value
                          })}
                          placeholder="+94 XX XXX XXXX"
                        />
                      </div>
                    </div>
                    
                    <div className="grid grid-cols-2 gap-4">
                      <div className="space-y-2">
                        <Label htmlFor="department">Department</Label>
                        <Input
                          id="department"
                          value={adminFormData.department}
                          onChange={(e) => setAdminFormData({
                            ...adminFormData,
                            department: e.target.value
                          })}
                          placeholder="e.g., Finance Division"
                        />
                      </div>
                      
                      <div className="space-y-2">
                        <Label htmlFor="role_id">Admin Role</Label>
                        <Select
                          value={adminFormData.role_id.toString()}
                          onValueChange={(value) => setAdminFormData({
                            ...adminFormData,
                            role_id: parseInt(value)
                          })}
                        >
                          <SelectTrigger>
                            <SelectValue placeholder="Select role" />
                          </SelectTrigger>
                          <SelectContent>
                            {adminRoles.map((role) => (
                              <SelectItem key={role.id} value={role.id.toString()}>
                                {role.role_name} - {role.institution}
                              </SelectItem>
                            ))}
                          </SelectContent>
                        </Select>
                      </div>
                    </div>
                  </div>
                  
                  <DialogFooter>
                    <Button variant="outline" onClick={() => setIsAdminDialogOpen(false)}>
                      Cancel
                    </Button>
                    <Button onClick={handleCreateAdmin}>
                      Create Admin
                    </Button>
                  </DialogFooter>
                </DialogContent>
              </Dialog>
            </div>

            {/* Admins Table */}
            <Card className="border-0 shadow-md">
              <CardContent className="p-0">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Admin Details</TableHead>
                      <TableHead>Contact</TableHead>
                      <TableHead>Role & Institution</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead>Last Login</TableHead>
                      <TableHead>Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {admins.map((admin) => (
                      <TableRow key={admin.id}>
                        <TableCell>
                          <div>
                            <p className="font-medium">{admin.full_name || admin.user_name}</p>
                            <p className="text-sm text-slate-500">@{admin.user_name}</p>
                            {admin.department && (
                              <p className="text-xs text-slate-400">{admin.department}</p>
                            )}
                          </div>
                        </TableCell>
                        <TableCell>
                          <div className="space-y-1">
                            <div className="flex items-center gap-1 text-sm">
                              <Mail className="h-3 w-3 text-slate-400" />
                              {admin.email}
                            </div>
                            {admin.phone && (
                              <div className="flex items-center gap-1 text-sm">
                                <Phone className="h-3 w-3 text-slate-400" />
                                {admin.phone}
                              </div>
                            )}
                          </div>
                        </TableCell>
                        <TableCell>
                          <div>
                            <p className="font-medium text-sm">
                              {admin.admin_roles?.role_name || 'No role assigned'}
                            </p>
                            <p className="text-xs text-slate-500">
                              {admin.admin_roles?.institution || 'No institution'}
                            </p>
                          </div>
                        </TableCell>
                        <TableCell>{getStatusBadge(admin.is_active)}</TableCell>
                        <TableCell>
                          {admin.last_login ? (
                            formatDate(admin.last_login)
                          ) : (
                            <span className="text-slate-400">Never</span>
                          )}
                        </TableCell>
                        <TableCell>
                          <div className="flex items-center gap-2">
                            <Button variant="ghost" size="sm">
                              <Edit className="h-4 w-4" />
                            </Button>
                            <Button 
                              variant="ghost" 
                              size="sm"
                              onClick={() => handleDeleteAdmin(admin.id)}
                            >
                              <Trash2 className="h-4 w-4" />
                            </Button>
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="permissions" className="space-y-6">
            <div>
              <h2 className="text-2xl font-bold text-slate-900">Permission Management</h2>
              <p className="text-slate-600">Configure detailed permissions for each admin role</p>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              {Object.entries(ROLE_PERMISSIONS).map(([key, permissions]) => (
                <Card key={key} className="border-0 shadow-md">
                  <CardHeader>
                    <CardTitle className="text-lg">
                      {key.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}
                    </CardTitle>
                    <CardDescription>
                      {permissions.length} permissions configured
                    </CardDescription>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-2">
                      {permissions.map((permission, index) => (
                        <div key={index} className="flex items-center justify-between p-2 bg-slate-50 rounded">
                          <span className="text-sm">{permission.replace(/_/g, ' ')}</span>
                          <CheckCircle className="h-4 w-4 text-green-600" />
                        </div>
                      ))}
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </TabsContent>
        </Tabs>
      </div>
    </div>
  )
}
