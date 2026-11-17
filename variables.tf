variable "azure_tenant_id" {
  description = "Microsoft Entra tenant ID used by the Azure Datadog integration."
  type        = string
}

variable "azure_client_id" {
  description = "Client/application ID of the Azure app registration for Datadog."
  type        = string
}

variable "azure_client_secret" {
  description = "Client secret for the Azure app registration. Prefer secretless federation where available."
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment tag for this Datadog configuration."
  type        = string
  default     = "dev"
}

variable "service_name" {
  description = "Service/platform tag applied to monitors."
  type        = string
  default     = "faj-azure-infrastructure"
}

variable "team" {
  description = "Owning team tag."
  type        = string
  default     = "platform"
}

variable "notification_targets" {
  description = "Datadog notification handles, such as @slack-platform-alerts or @pagerduty."
  type        = string
  default     = ""
}

variable "enable_vm_cpu_monitor" {
  type        = bool
  description = "Create the Azure VM CPU monitor. Requires azure.vm.percentage_cpu to be present."
  default     = true
}

variable "enable_app_service_5xx_monitor" {
  type        = bool
  description = "Create the App Service HTTP 5xx monitor after confirming its metric name in Metrics Explorer."
  default     = false
}
