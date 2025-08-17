import ballerina/http;
import ballerina/time;
import ballerina/log;

# Admin Roles Management Service
public class AdminsService {
    private http:Client supabaseClient;
    private string supabaseServiceRoleKey;
    
    public function init(http:Client supabaseClient, int port, string supabaseUrl, string supabaseServiceRoleKey) {
        self.supabaseClient = supabaseClient;
        self.supabaseServiceRoleKey = supabaseServiceRoleKey;
        log:printInfo("AdminsService initialized");
    }
    
    # Get headers for Supabase requests
    #
    # + includePrefer - Whether to include Prefer header for POST/PUT operations
    # + return - Headers map
    public function getHeaders(boolean includePrefer = false) returns map<string> {
        map<string> headers = {
            "apikey": self.supabaseServiceRoleKey,
            "Authorization": "Bearer " + self.supabaseServiceRoleKey,
            "Content-Type": "application/json"
        };
        
        if includePrefer {
            headers["Prefer"] = "return=representation";
        }
        
        return headers;
    }

    # Get all admin roles
    #
    # + return - Admin roles list or error
    public function getAllAdminRoles() returns json|error {
        do {
            map<string> headers = self.getHeaders();
            http:Response response = check self.supabaseClient->get("/rest/v1/admin_roles?select=*&order=created_at.desc", headers);
            
            if response.statusCode != 200 {
                return error("Failed to get admin roles: " + response.statusCode.toString());
            }
            
            json result = check response.getJsonPayload();
            
            return {
                "success": true,
                "data": result,
                "message": "Admin roles retrieved successfully",
                "timestamp": time:utcNow()[0]
            };
        } on fail var e {
            log:printError("Error in getAllAdminRoles", e);
            return error("Failed to get admin roles: " + e.message());
        }
    }

    # Create a new admin role
    #
    # + roleData - Admin role data
    # + return - Success response or error
    public function createAdminRole(json roleData) returns json|error {
        do {
            // Validate required fields
            string[] errors = [];
            
            json|error roleName = roleData.role_name;
            if roleName is error || roleName.toString().trim().length() == 0 {
                errors.push("Role name is required and cannot be empty");
            }
            
            json|error institution = roleData.institution;
            if institution is error || institution.toString().trim().length() == 0 {
                errors.push("Institution is required and cannot be empty");
            }
            
            json|error permissions = roleData.permissions;
            if permissions is error {
                errors.push("Permissions are required");
            }
            
            if errors.length() > 0 {
                return {
                    "success": false,
                    "message": "Validation failed",
                    "errors": errors,
                    "timestamp": time:utcNow()[0]
                };
            }
            
            // Prepare payload with default values
            map<anydata> payloadMap = {
                "role_name": roleName.toString().trim(),
                "institution": institution.toString().trim(),
                "permissions": permissions,
                "is_active": true,
                "created_at": "now()",
                "updated_at": "now()"
            };
            
            // Add optional fields
            json|error description = roleData.description;
            if description is json && description.toString().trim().length() > 0 {
                payloadMap["description"] = description.toString().trim();
            }
            
            json|error ministryLevel = roleData.ministry_level;
            if ministryLevel is json {
                payloadMap["ministry_level"] = ministryLevel;
            }
            
            json payload = payloadMap;
            
            map<string> headers = self.getHeaders(true);
            http:Response response = check self.supabaseClient->post("/rest/v1/admin_roles", payload, headers);
            
            if response.statusCode == 201 {
                json|error result = response.getJsonPayload();
                if result is error {
                    return {
                        "success": true,
                        "message": "Admin role created successfully",
                        "data": payload,
                        "timestamp": time:utcNow()[0]
                    };
                } else {
                    json[] roles = check result.ensureType();
                    if roles.length() > 0 {
                        return {
                            "success": true,
                            "message": "Admin role created successfully",
                            "data": roles[0],
                            "timestamp": time:utcNow()[0]
                        };
                    } else {
                        return {
                            "success": true,
                            "message": "Admin role created successfully",
                            "data": payload,
                            "timestamp": time:utcNow()[0]
                        };
                    }
                }
            } else {
                return error("Failed to create admin role: " + response.statusCode.toString());
            }
        } on fail var e {
            log:printError("Error in createAdminRole", e);
            return error("Failed to create admin role: " + e.message());
        }
    }

    # Get all admins
    #
    # + return - Admins list or error
    public function getAllAdmins() returns json|error {
        do {
            map<string> headers = self.getHeaders();
            http:Response response = check self.supabaseClient->get("/rest/v1/admins?select=*,admin_roles(role_name,institution,permissions)&order=created_at.desc", headers);
            
            if response.statusCode != 200 {
                return error("Failed to get admins: " + response.statusCode.toString());
            }
            
            json result = check response.getJsonPayload();
            
            return {
                "success": true,
                "data": result,
                "message": "Admins retrieved successfully",
                "timestamp": time:utcNow()[0]
            };
        } on fail var e {
            log:printError("Error in getAllAdmins", e);
            return error("Failed to get admins: " + e.message());
        }
    }

    # Create a new admin
    #
    # + adminData - Admin data
    # + return - Success response or error
    public function createAdmin(json adminData) returns json|error {
        do {
            // Validate required fields
            string[] errors = [];
            
            json|error userName = adminData.user_name;
            if userName is error || userName.toString().trim().length() == 0 {
                errors.push("Username is required and cannot be empty");
            }
            
            json|error email = adminData.email;
            if email is error || email.toString().trim().length() == 0 {
                errors.push("Email is required and cannot be empty");
            } else if !email.toString().includes("@") {
                errors.push("Invalid email format");
            }
            
            json|error roleId = adminData.role_id;
            if roleId is error {
                errors.push("Role ID is required");
            }
            
            if errors.length() > 0 {
                return {
                    "success": false,
                    "message": "Validation failed",
                    "errors": errors,
                    "timestamp": time:utcNow()[0]
                };
            }
            
            // Prepare payload with default values
            map<anydata> payloadMap = {
                "user_name": userName.toString().trim(),
                "email": email.toString().trim(),
                "role_id": roleId,
                "is_active": true,
                "last_login": null,
                "created_at": "now()",
                "updated_at": "now()"
            };
            
            // Add optional fields
            json|error fullName = adminData.full_name;
            if fullName is json && fullName.toString().trim().length() > 0 {
                payloadMap["full_name"] = fullName.toString().trim();
            }
            
            json|error phone = adminData.phone;
            if phone is json && phone.toString().trim().length() > 0 {
                payloadMap["phone"] = phone.toString().trim();
            }
            
            json|error department = adminData.department;
            if department is json && department.toString().trim().length() > 0 {
                payloadMap["department"] = department.toString().trim();
            }
            
            json payload = payloadMap;
            
            map<string> headers = self.getHeaders(true);
            http:Response response = check self.supabaseClient->post("/rest/v1/admins", payload, headers);
            
            if response.statusCode == 201 {
                json|error result = response.getJsonPayload();
                if result is error {
                    return {
                        "success": true,
                        "message": "Admin created successfully",
                        "data": payload,
                        "timestamp": time:utcNow()[0]
                    };
                } else {
                    json[] admins = check result.ensureType();
                    if admins.length() > 0 {
                        return {
                            "success": true,
                            "message": "Admin created successfully",
                            "data": admins[0],
                            "timestamp": time:utcNow()[0]
                        };
                    } else {
                        return {
                            "success": true,
                            "message": "Admin created successfully",
                            "data": payload,
                            "timestamp": time:utcNow()[0]
                        };
                    }
                }
            } else {
                return error("Failed to create admin: " + response.statusCode.toString());
            }
        } on fail var e {
            log:printError("Error in createAdmin", e);
            return error("Failed to create admin: " + e.message());
        }
    }

    # Update admin
    #
    # + adminId - Admin ID to update
    # + updateData - Updated admin data
    # + return - Success response or error
    public function updateAdmin(int adminId, json updateData) returns json|error {
        do {
            map<anydata> payloadMap = {};
            
            json|error userName = updateData.user_name;
            if userName is json && userName.toString().trim().length() > 0 {
                payloadMap["user_name"] = userName.toString().trim();
            }
            
            json|error email = updateData.email;
            if email is json && email.toString().trim().length() > 0 {
                if !email.toString().includes("@") {
                    return {
                        "success": false,
                        "message": "Invalid email format",
                        "timestamp": time:utcNow()[0]
                    };
                }
                payloadMap["email"] = email.toString().trim();
            }
            
            json|error fullName = updateData.full_name;
            if fullName is json {
                payloadMap["full_name"] = fullName.toString().trim();
            }
            
            json|error phone = updateData.phone;
            if phone is json {
                payloadMap["phone"] = phone.toString().trim();
            }
            
            json|error department = updateData.department;
            if department is json {
                payloadMap["department"] = department.toString().trim();
            }
            
            json|error roleId = updateData.role_id;
            if roleId is json {
                payloadMap["role_id"] = roleId;
            }
            
            json|error isActive = updateData.is_active;
            if isActive is json {
                payloadMap["is_active"] = isActive;
            }
            
            if payloadMap.length() == 0 {
                return {
                    "success": false,
                    "message": "No valid fields provided for update",
                    "timestamp": time:utcNow()[0]
                };
            }
            
            payloadMap["updated_at"] = "now()";
            json payload = payloadMap;
            
            map<string> headers = self.getHeaders(true);
            string endpoint = "/rest/v1/admins?id=eq." + adminId.toString();
            http:Response response = check self.supabaseClient->patch(endpoint, payload, headers);
            
            if response.statusCode == 200 {
                json result = check response.getJsonPayload();
                return {
                    "success": true,
                    "message": "Admin updated successfully",
                    "data": result,
                    "timestamp": time:utcNow()[0]
                };
            } else {
                return error("Failed to update admin: " + response.statusCode.toString());
            }
        } on fail var e {
            log:printError("Error in updateAdmin", e);
            return error("Failed to update admin: " + e.message());
        }
    }

    # Delete admin
    #
    # + adminId - Admin ID to delete
    # + return - Success response or error
    public function deleteAdmin(int adminId) returns json|error {
        do {
            map<string> headers = self.getHeaders();
            string endpoint = "/rest/v1/admins?id=eq." + adminId.toString();
            http:Response response = check self.supabaseClient->delete(endpoint, headers);
            
            if response.statusCode == 204 || response.statusCode == 200 {
                return {
                    "success": true,
                    "message": "Admin deleted successfully",
                    "timestamp": time:utcNow()[0]
                };
            } else {
                return error("Failed to delete admin: " + response.statusCode.toString());
            }
        } on fail var e {
            log:printError("Error in deleteAdmin", e);
            return error("Failed to delete admin: " + e.message());
        }
    }

    # Authenticate admin
    #
    # + email - Admin email
    # + return - Admin details with role or error
    public function authenticateAdmin(string email) returns json|error {
        do {
            map<string> headers = self.getHeaders();
            string endpoint = "/rest/v1/admins?select=*,admin_roles(*)&email=eq." + email + "&is_active=eq.true";
            http:Response response = check self.supabaseClient->get(endpoint, headers);
            
            if response.statusCode != 200 {
                return error("Failed to authenticate admin: " + response.statusCode.toString());
            }
            
            json result = check response.getJsonPayload();
            json[] admins = check result.ensureType();
            
            if admins.length() == 0 {
                return {
                    "success": false,
                    "message": "Admin not found or inactive",
                    "timestamp": time:utcNow()[0]
                };
            }
            
            // Update last login
            map<anydata> updatePayload = {
                "last_login": "now()",
                "updated_at": "now()"
            };
            
            json adminData = admins[0];
            json|error adminId = adminData.id;
            if adminId is json {
                string updateEndpoint = "/rest/v1/admins?id=eq." + adminId.toString();
                http:Response updateResponse = check self.supabaseClient->patch(updateEndpoint, updatePayload, headers);
            }
            
            return {
                "success": true,
                "message": "Admin authenticated successfully",
                "data": admins[0],
                "timestamp": time:utcNow()[0]
            };
        } on fail var e {
            log:printError("Error in authenticateAdmin", e);
            return error("Failed to authenticate admin: " + e.message());
        }
    }

    # Check admin permissions
    #
    # + adminId - Admin ID
    # + requiredPermission - Required permission to check
    # + return - Permission check result
    public function checkAdminPermission(int adminId, string requiredPermission) returns json|error {
        do {
            map<string> headers = self.getHeaders();
            string endpoint = "/rest/v1/admins?select=admin_roles(permissions)&id=eq." + adminId.toString() + "&is_active=eq.true";
            http:Response response = check self.supabaseClient->get(endpoint, headers);
            
            if response.statusCode != 200 {
                return error("Failed to check admin permissions: " + response.statusCode.toString());
            }
            
            json result = check response.getJsonPayload();
            json[] admins = check result.ensureType();
            
            if admins.length() == 0 {
                return {
                    "success": false,
                    "hasPermission": false,
                    "message": "Admin not found or inactive",
                    "timestamp": time:utcNow()[0]
                };
            }
            
            json adminData = admins[0];
            json|error roleData = adminData.admin_roles;
            
            if roleData is json {
                json|error permissions = roleData.permissions;
                if permissions is json {
                    json[] permissionArray = check permissions.ensureType();
                    boolean hasPermission = false;
                    
                    foreach json permission in permissionArray {
                        if permission.toString() == requiredPermission {
                            hasPermission = true;
                            break;
                        }
                    }
                    
                    return {
                        "success": true,
                        "hasPermission": hasPermission,
                        "permissions": permissions,
                        "timestamp": time:utcNow()[0]
                    };
                }
            }
            
            return {
                "success": false,
                "hasPermission": false,
                "message": "No permissions found for admin",
                "timestamp": time:utcNow()[0]
            };
        } on fail var e {
            log:printError("Error in checkAdminPermission", e);
            return error("Failed to check admin permissions: " + e.message());
        }
    }

    # Get admins by role
    #
    # + roleId - Role ID to filter by
    # + return - Admins list or error
    public function getAdminsByRole(int roleId) returns json|error {
        do {
            map<string> headers = self.getHeaders();
            string endpoint = "/rest/v1/admins?select=*,admin_roles(role_name,institution)&role_id=eq." + roleId.toString() + "&order=created_at.desc";
            http:Response response = check self.supabaseClient->get(endpoint, headers);
            
            if response.statusCode != 200 {
                return error("Failed to get admins by role: " + response.statusCode.toString());
            }
            
            json result = check response.getJsonPayload();
            
            return {
                "success": true,
                "data": result,
                "message": "Admins retrieved successfully",
                "timestamp": time:utcNow()[0]
            };
        } on fail var e {
            log:printError("Error in getAdminsByRole", e);
            return error("Failed to get admins by role: " + e.message());
        }
    }
}
