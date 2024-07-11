##################################################
# GuardDuty Organizations Delegated Admin
##################################################
variable "guardduty_detector_id" {
  description = "The detector ID of the GuardDuty account."
  type        = string
}

variable "enable_s3_protection" {
  description = "Configure and enable S3 protection. Defaults to `true`."
  type        = bool
  default     = true
}

variable "enable_kubernetes_protection" {
  description = "Configure and enable Kubernetes audit logs as a data source for Kubernetes protection. Defaults to `true`."
  type        = bool
  default     = true
}

variable "enable_malware_protection" {
  description = "Configure and enable Malware Protection as data source for EC2 instances with findings for the detector. Defaults to `true`."
  type        = bool
  default     = true
}

variable "auto_enable_rds_login_events" {
  description = "Auto-enable RDS login events monitoring for the member accounts within the organization."
  type        = string
  default     = null
   validation {
    condition     = var.auto_enable_rds_login_events == null || contains(["ALL", "NONE", "NEW"], coalesce(var.auto_enable_rds_login_events, 0))
    error_message = "The auto_enable value must be one of: ALL, NONE, NEW."
  }
}

variable "auto_enable_lambda_network_logs" {
  description = "Auto-enable Lambda network logs monitoring for the member accounts within the organization."
  type        = string
  default     = null
  validation {
    condition     = var.auto_enable_lambda_network_logs == null || contains(["ALL", "NONE", "NEW"], coalesce(var.auto_enable_lambda_network_logs, 0))
    error_message = "The auto_enable value must be one of: ALL, NONE, NEW."
  }
}

variable "auto_enable_eks_runtime_monitoring" {
  description = "Auto-enable EKS Runtime Monitoring for the member accounts within the organization."
  type        = string
  default     = null
  validation {
    condition     = var.auto_enable_eks_runtime_monitoring == null || contains(["ALL", "NONE", "NEW"], coalesce(var.auto_enable_eks_runtime_monitoring, 0))
    error_message = "The auto_enable value must be one of: ALL, NONE, NEW."
  }
}

variable "auto_enable_runtime_monitoring" {
  description = "Auto-enable Runtime Monitoring for the member accounts within the organization."
  type        = string
  default     = null
  validation {
    condition     = var.auto_enable_runtime_monitoring == null || contains(["ALL", "NONE", "NEW"], coalesce(var.auto_enable_runtime_monitoring, 0))
    error_message = "The auto_enable value must be one of: ALL, NONE, NEW."
  }
}

variable "auto_enable_eks_addon_management" {
  description = "Auto-enable EKS Addon Management additional configuration of EKS Runtime Monitoring/Runtime Monitoring for the member accounts within the organization."
  type        = string
  default     = null
  validation {
    condition     = var.auto_enable_eks_addon_management == null || contains(["ALL", "NONE", "NEW"], coalesce(var.auto_enable_eks_addon_management, 0))
    error_message = "The auto_enable value must be one of: ALL, NONE, NEW."
  }
}

variable "auto_enable_ecs_fargate_agent_management" {
  description = "Auto-enable ECS Fargate Agent Management  additional configuration of Runtime Monitoring for the member accounts within the organization."
  type        = string
  default     = null
  validation {
    condition     = var.auto_enable_ecs_fargate_agent_management == null || contains(["ALL", "NONE", "NEW"], coalesce(var.auto_enable_ecs_fargate_agent_management, 0))
    error_message = "The auto_enable value must be one of: ALL, NONE, NEW."
  }
}

variable "auto_enable_ec2_agent_management" {
  description = "Auto-enable EC2 Agent Management additional configuration of Runtime Monitoring for the member accounts within the organization."
  type        = string
  default     = null
  validation {
    condition     = var.auto_enable_ec2_agent_management == null || contains(["ALL", "NONE", "NEW"], coalesce(var.auto_enable_ec2_agent_management, 0))
    error_message = "The auto_enable value must be one of: ALL, NONE, NEW."
  }
}

variable "admin_account_id" {
  description = "AWS Organizations Admin Account Id. Defaults to `null`"
  type        = string
  default     = null
}

variable "auto_enable_org_config" {
  description = "When this setting is enabled, all new accounts that are created in, or added to, the organization are added as a member accounts of the organization’s GuardDuty delegated administrator and GuardDuty is enabled in that AWS Region."
  type        = bool
  default     = null
}

variable "auto_enable_organization_members" {
  description = "Indicates the auto-enablement configuration of GuardDuty for the member accounts in the organization. Valid values are `ALL`, `NEW`, `NONE`. Defaults to `NEW`."
  type        = string
  default     = "NEW"
}
