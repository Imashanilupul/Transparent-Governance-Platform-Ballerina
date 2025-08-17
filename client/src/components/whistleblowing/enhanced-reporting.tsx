"use client"

import { useState, useEffect } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { useToast } from "@/hooks/use-toast"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from "@/components/ui/command"
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover"
import { Shield, FileText, CheckCircle, AlertTriangle, Search, ChevronDown } from "lucide-react"
import { superAdminService, type AdminRole } from "@/services/super-admin"
import { reportService } from "@/services/report"
import { petitionService } from "@/services/petition"

interface ReportFormData {
  category: string
  title: string
  description: string
  target_admin_role_id: number | null
  evidence: File | null
}

interface PetitionFormData {
  title: string
  description: string
  targetSignatures: number
  assigned_admin_role_id: number | null
}

export function EnhancedWhistleblowingSystem({ walletAddress }: { walletAddress?: string }) {
  const { toast } = useToast()
  
  const [adminRoles, setAdminRoles] = useState<AdminRole[]>([])
  const [filteredRoles, setFilteredRoles] = useState<AdminRole[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [isRolePopoverOpen, setIsRolePopoverOpen] = useState(false)
  const [isPetitionRolePopoverOpen, setIsPetitionRolePopoverOpen] = useState(false)
  
  const [reportForm, setReportForm] = useState<ReportFormData>({
    category: "",
    title: "",
    description: "",
    target_admin_role_id: null,
    evidence: null,
  })

  const [petitionForm, setPetitionForm] = useState<PetitionFormData>({
    title: "",
    description: "",
    targetSignatures: 10000,
    assigned_admin_role_id: null,
  })

  const [isSubmittingReport, setIsSubmittingReport] = useState(false)
  const [isCreatingPetition, setIsCreatingPetition] = useState(false)

  // Report categories with suggested admin roles
  const reportCategories = [
    { 
      value: "corruption", 
      label: "Corruption & Bribery",
      suggestedInstitutions: ["Commission to Investigate Allegations of Bribery or Corruption"]
    },
    { 
      value: "financial_misconduct", 
      label: "Financial Misconduct",
      suggestedInstitutions: ["Ministry of Finance", "Auditor General's Department"]
    },
    { 
      value: "procurement_irregularities", 
      label: "Procurement Irregularities",
      suggestedInstitutions: ["Ministry of Finance", "Auditor General's Department"]
    },
    { 
      value: "abuse_of_power", 
      label: "Abuse of Power",
      suggestedInstitutions: ["Commission to Investigate Allegations of Bribery or Corruption"]
    },
    { 
      value: "environmental_violations", 
      label: "Environmental Violations",
      suggestedInstitutions: ["Ministry of Environment"]
    },
    { 
      value: "health_safety", 
      label: "Health & Safety Issues",
      suggestedInstitutions: ["Ministry of Health"]
    },
    { 
      value: "education_issues", 
      label: "Education System Issues",
      suggestedInstitutions: ["Ministry of Education"]
    },
    { 
      value: "transport_issues", 
      label: "Transport & Infrastructure",
      suggestedInstitutions: ["Ministry of Transport"]
    },
    { 
      value: "other", 
      label: "Other Government Issues",
      suggestedInstitutions: []
    }
  ]

  useEffect(() => {
    loadAdminRoles()
  }, [])

  useEffect(() => {
    // Filter roles based on search query
    const filtered = adminRoles.filter(role =>
      role.role_name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      role.institution.toLowerCase().includes(searchQuery.toLowerCase())
    )
    setFilteredRoles(filtered)
  }, [adminRoles, searchQuery])

  const loadAdminRoles = async () => {
    try {
      const response = await superAdminService.getAllAdminRoles()
      if (response.success) {
        setAdminRoles(response.data.filter(role => role.is_active))
      }
    } catch (error) {
      console.error('Failed to load admin roles:', error)
    }
  }

  const getSuggestedRoles = (category: string) => {
    const categoryData = reportCategories.find(cat => cat.value === category)
    if (!categoryData?.suggestedInstitutions.length) return adminRoles

    return adminRoles.filter(role =>
      categoryData.suggestedInstitutions.some(institution =>
        role.institution.toLowerCase().includes(institution.toLowerCase())
      )
    )
  }

  const handleCategoryChange = (category: string) => {
    setReportForm({ ...reportForm, category, target_admin_role_id: null })
    
    // Auto-suggest the first matching admin role
    const suggestedRoles = getSuggestedRoles(category)
    if (suggestedRoles.length > 0) {
      setReportForm(prev => ({ ...prev, target_admin_role_id: suggestedRoles[0].id }))
    }
  }

  const handleSubmitReport = async () => {
    if (!reportForm.title.trim() || !reportForm.description.trim() || !reportForm.category) {
      toast({
        title: "Error",
        description: "Please fill in all required fields",
        variant: "destructive"
      })
      return
    }

    setIsSubmittingReport(true)
    try {
      // Create report data
      const reportData = {
        report_title: reportForm.title,
        description: reportForm.description,
        category: reportForm.category,
        target_admin_role_id: reportForm.target_admin_role_id,
        priority: "MEDIUM",
        evidence_hash: "placeholder_hash", // In real implementation, upload file and get hash
        wallet_address: walletAddress || null
      }

      const response = await reportService.createReport(reportData)
      
      if (response.success) {
        toast({
          title: "Report Submitted Successfully",
          description: `Your report has been assigned to ${getSelectedRoleName(reportForm.target_admin_role_id)} for investigation.`
        })
        
        // Reset form
        setReportForm({
          category: "",
          title: "",
          description: "",
          target_admin_role_id: null,
          evidence: null,
        })
      } else {
        toast({
          title: "Error",
          description: response.message || "Failed to submit report",
          variant: "destructive"
        })
      }
    } catch (error) {
      console.error('Failed to submit report:', error)
      toast({
        title: "Error",
        description: "Failed to submit report. Please try again.",
        variant: "destructive"
      })
    } finally {
      setIsSubmittingReport(false)
    }
  }

  const handleCreatePetition = async () => {
    if (!petitionForm.title.trim() || !petitionForm.description.trim()) {
      toast({
        title: "Error",
        description: "Please fill in all required fields",
        variant: "destructive"
      })
      return
    }

    setIsCreatingPetition(true)
    try {
      const petitionData = {
        title: petitionForm.title,
        description: petitionForm.description,
        required_signature_count: petitionForm.targetSignatures,
        assigned_admin_role_id: petitionForm.assigned_admin_role_id
      }

      const response = await petitionService.createPetition(petitionData)
      
      if (response.success) {
        toast({
          title: "Petition Created Successfully",
          description: `Your petition will be reviewed by ${getSelectedPetitionRoleName(petitionForm.assigned_admin_role_id)} when the signature threshold is met.`
        })
        
        // Reset form
        setPetitionForm({
          title: "",
          description: "",
          targetSignatures: 10000,
          assigned_admin_role_id: null,
        })
      } else {
        toast({
          title: "Error",
          description: response.message || "Failed to create petition",
          variant: "destructive"
        })
      }
    } catch (error) {
      console.error('Failed to create petition:', error)
      toast({
        title: "Error",
        description: "Failed to create petition. Please try again.",
        variant: "destructive"
      })
    } finally {
      setIsCreatingPetition(false)
    }
  }

  const getSelectedRoleName = (roleId: number | null) => {
    if (!roleId) return "the appropriate government authority"
    const role = adminRoles.find(r => r.id === roleId)
    return role ? `${role.role_name} (${role.institution})` : "the selected authority"
  }

  const getSelectedPetitionRoleName = (roleId: number | null) => {
    if (!roleId) return "the relevant government authority"
    const role = adminRoles.find(r => r.id === roleId)
    return role ? `${role.role_name} (${role.institution})` : "the selected authority"
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h2 className="text-2xl font-bold text-slate-900">Enhanced Citizen Reporting System</h2>
        <p className="text-slate-600">
          Submit reports and petitions with intelligent routing to the appropriate government authorities
        </p>
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Submit Report */}
        <Card className="border-0 shadow-md">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Shield className="h-5 w-5" />
              Submit Report to Government Authority
            </CardTitle>
            <CardDescription>
              Reports are automatically routed to the most relevant government institution
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label className="text-sm font-medium">Report Category</Label>
              <Select
                value={reportForm.category}
                onValueChange={handleCategoryChange}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select category type" />
                </SelectTrigger>
                <SelectContent>
                  {reportCategories.map((category) => (
                    <SelectItem key={category.value} value={category.value}>
                      {category.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label className="text-sm font-medium">Report Title</Label>
              <Input
                placeholder="Brief, descriptive title of the issue"
                value={reportForm.title}
                onChange={(e) => setReportForm({ ...reportForm, title: e.target.value })}
              />
            </div>

            <div className="space-y-2">
              <Label className="text-sm font-medium">Detailed Description</Label>
              <Textarea
                placeholder="Provide detailed information about the issue, including dates, locations, people involved, and any other relevant details..."
                rows={4}
                value={reportForm.description}
                onChange={(e) => setReportForm({ ...reportForm, description: e.target.value })}
              />
            </div>

            <div className="space-y-2">
              <Label className="text-sm font-medium">Assign to Government Authority</Label>
              <Popover open={isRolePopoverOpen} onOpenChange={setIsRolePopoverOpen}>
                <PopoverTrigger asChild>
                  <Button variant="outline" className="w-full justify-between">
                    {reportForm.target_admin_role_id
                      ? getSelectedRoleName(reportForm.target_admin_role_id)
                      : "Select authority..."}
                    <ChevronDown className="h-4 w-4 opacity-50" />
                  </Button>
                </PopoverTrigger>
                <PopoverContent className="w-full p-0" align="start">
                  <Command>
                    <CommandInput 
                      placeholder="Search institutions..." 
                      value={searchQuery}
                      onValueChange={setSearchQuery}
                    />
                    <CommandList>
                      <CommandEmpty>No authority found.</CommandEmpty>
                      <CommandGroup heading="Suggested (based on category)">
                        {reportForm.category && getSuggestedRoles(reportForm.category).map((role) => (
                          <CommandItem
                            key={role.id}
                            onSelect={() => {
                              setReportForm({ ...reportForm, target_admin_role_id: role.id })
                              setIsRolePopoverOpen(false)
                            }}
                            className="flex flex-col items-start"
                          >
                            <span className="font-medium">{role.role_name}</span>
                            <span className="text-sm text-slate-500">{role.institution}</span>
                          </CommandItem>
                        ))}
                      </CommandGroup>
                      <CommandGroup heading="All Authorities">
                        {filteredRoles
                          .filter(role => !getSuggestedRoles(reportForm.category).some(suggested => suggested.id === role.id))
                          .map((role) => (
                          <CommandItem
                            key={role.id}
                            onSelect={() => {
                              setReportForm({ ...reportForm, target_admin_role_id: role.id })
                              setIsRolePopoverOpen(false)
                            }}
                            className="flex flex-col items-start"
                          >
                            <span className="font-medium">{role.role_name}</span>
                            <span className="text-sm text-slate-500">{role.institution}</span>
                          </CommandItem>
                        ))}
                      </CommandGroup>
                    </CommandList>
                  </Command>
                </PopoverContent>
              </Popover>
              {reportForm.target_admin_role_id && (
                <div className="rounded-lg bg-green-50 p-3">
                  <div className="flex items-center gap-2 text-sm text-green-800">
                    <CheckCircle className="h-4 w-4" />
                    <span className="font-medium">Authority Selected</span>
                  </div>
                  <p className="mt-1 text-xs text-green-700">
                    Your report will be sent directly to {getSelectedRoleName(reportForm.target_admin_role_id)} for investigation and appropriate action.
                  </p>
                </div>
              )}
            </div>

            {/* Wallet Status Display */}
            {walletAddress ? (
              <div className="rounded-lg bg-green-50 p-3">
                <div className="flex items-center gap-2 text-sm text-green-800">
                  <CheckCircle className="h-4 w-4" />
                  <span className="font-medium">Wallet Connected</span>
                </div>
                <p className="mt-1 text-xs text-green-700">
                  {walletAddress.slice(0, 6)}...{walletAddress.slice(-4)} - Ready to submit anonymous reports
                </p>
              </div>
            ) : (
              <div className="rounded-lg bg-yellow-50 p-3">
                <div className="flex items-center gap-2 text-sm text-yellow-800">
                  <AlertTriangle className="h-4 w-4" />
                  <span className="font-medium">Wallet Required</span>
                </div>
                <p className="mt-1 text-xs text-yellow-700">
                  Please connect your wallet to submit reports securely.
                </p>
              </div>
            )}

            <Button
              className="w-full"
              onClick={handleSubmitReport}
              disabled={
                !walletAddress ||
                isSubmittingReport ||
                !reportForm.title.trim() ||
                !reportForm.description.trim() ||
                !reportForm.category ||
                !reportForm.target_admin_role_id
              }
            >
              {isSubmittingReport ? (
                <>
                  <span className="mr-2 animate-spin">⏳</span>
                  Submitting Report...
                </>
              ) : !walletAddress ? (
                "🔐 Connect Wallet to Submit"
              ) : (
                "🛡️ Submit Report to Government Authority"
              )}
            </Button>
          </CardContent>
        </Card>

        {/* Create Petition */}
        <Card className="border-0 shadow-md">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <FileText className="h-5 w-5" />
              Create Petition with Authority Assignment
            </CardTitle>
            <CardDescription>
              Petitions are automatically routed to relevant government authorities when thresholds are met
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label className="text-sm font-medium">Petition Title</Label>
              <Input
                placeholder="Clear, actionable petition title"
                value={petitionForm.title}
                onChange={(e) => setPetitionForm({ ...petitionForm, title: e.target.value })}
              />
            </div>

            <div className="space-y-2">
              <Label className="text-sm font-medium">Description</Label>
              <Textarea
                placeholder="Detailed explanation of the petition and desired outcome..."
                rows={4}
                value={petitionForm.description}
                onChange={(e) => setPetitionForm({ ...petitionForm, description: e.target.value })}
              />
            </div>

            <div className="space-y-2">
              <Label className="text-sm font-medium">Target Signatures</Label>
              <Input
                type="number"
                min="1"
                placeholder="Enter target signature count"
                value={petitionForm.targetSignatures.toString()}
                onChange={(e) => {
                  const value = e.target.value
                  const numValue = value === "" ? 0 : Number.parseInt(value)
                  if (!isNaN(numValue) && numValue >= 0) {
                    setPetitionForm({ ...petitionForm, targetSignatures: numValue })
                  }
                }}
              />
            </div>

            <div className="space-y-2">
              <Label className="text-sm font-medium">Assign to Government Authority (Optional)</Label>
              <Popover open={isPetitionRolePopoverOpen} onOpenChange={setIsPetitionRolePopoverOpen}>
                <PopoverTrigger asChild>
                  <Button variant="outline" className="w-full justify-between">
                    {petitionForm.assigned_admin_role_id
                      ? getSelectedPetitionRoleName(petitionForm.assigned_admin_role_id)
                      : "Select authority (optional)..."}
                    <ChevronDown className="h-4 w-4 opacity-50" />
                  </Button>
                </PopoverTrigger>
                <PopoverContent className="w-full p-0" align="start">
                  <Command>
                    <CommandInput 
                      placeholder="Search institutions..." 
                      value={searchQuery}
                      onValueChange={setSearchQuery}
                    />
                    <CommandList>
                      <CommandEmpty>No authority found.</CommandEmpty>
                      <CommandGroup>
                        <CommandItem
                          onSelect={() => {
                            setPetitionForm({ ...petitionForm, assigned_admin_role_id: null })
                            setIsPetitionRolePopoverOpen(false)
                          }}
                        >
                          <span className="text-slate-500">No specific authority (general petition)</span>
                        </CommandItem>
                        {filteredRoles.map((role) => (
                          <CommandItem
                            key={role.id}
                            onSelect={() => {
                              setPetitionForm({ ...petitionForm, assigned_admin_role_id: role.id })
                              setIsPetitionRolePopoverOpen(false)
                            }}
                            className="flex flex-col items-start"
                          >
                            <span className="font-medium">{role.role_name}</span>
                            <span className="text-sm text-slate-500">{role.institution}</span>
                          </CommandItem>
                        ))}
                      </CommandGroup>
                    </CommandList>
                  </Command>
                </PopoverContent>
              </Popover>
              {petitionForm.assigned_admin_role_id && (
                <div className="rounded-lg bg-blue-50 p-3">
                  <div className="flex items-center gap-2 text-sm text-blue-800">
                    <CheckCircle className="h-4 w-4" />
                    <span className="font-medium">Authority Assigned</span>
                  </div>
                  <p className="mt-1 text-xs text-blue-700">
                    When the signature threshold is reached, {getSelectedPetitionRoleName(petitionForm.assigned_admin_role_id)} will be notified to provide an official response.
                  </p>
                </div>
              )}
            </div>

            <div className="rounded-lg bg-green-50 p-3">
              <div className="flex items-center gap-2 text-sm text-green-800">
                <CheckCircle className="h-4 w-4" />
                <span className="font-medium">Smart Contract Execution</span>
              </div>
              <p className="mt-1 text-xs text-green-700">
                When the signature threshold is reached, the petition will automatically trigger an official response within 30 days.
              </p>
            </div>

            <Button
              className="w-full"
              onClick={handleCreatePetition}
              disabled={
                isCreatingPetition ||
                !petitionForm.title.trim() ||
                !petitionForm.description.trim()
              }
            >
              {isCreatingPetition ? (
                <>
                  <span className="mr-2 animate-spin">⏳</span>
                  Creating Petition...
                </>
              ) : (
                "🗳️ Create Petition with Authority Assignment"
              )}
            </Button>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
