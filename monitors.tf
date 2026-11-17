locals {
  common_tags = [
    "managed_by:terraform",
    "cloud:azure",
    "service:${var.service_name}",
    "env:${var.environment}",
    "team:${var.team}",
  ]

  notify = trimspace(var.notification_targets) == "" ? "" : "\n\nNotify: ${var.notification_targets}"
}

# Azure VM CPU utilization. Metric name is documented by Datadog's Azure VM integration.
resource "datadog_monitor" "azure_vm_cpu_high" {
  count = var.enable_vm_cpu_monitor ? 1 : 0

  name = "[${upper(var.environment)}] Azure VM CPU utilization high"
  type = "metric alert"

  query = "avg(last_10m):avg:azure.vm.percentage_cpu{*} by {host} > 85"

  message = <<-EOT
    Azure VM CPU utilization has exceeded 85% for 10 minutes.
    Investigate workload demand, processes, and VM sizing.
    Include the affected host and resource_group in the incident.
    ${local.notify}
  EOT

  monitor_thresholds {
    warning  = 75
    critical = 85
  }

  evaluation_delay    = 300
  require_full_window = true
  notify_no_data      = false
  renotify_interval   = 60
  priority            = 3
  include_tags        = true
  tags                = local.common_tags
}

# Optional App Service HTTP 5xx monitor.
# Keep disabled until you confirm the exact metric name and tags in Datadog
# Metrics Explorer for your App Service resource(s).
resource "datadog_monitor" "app_service_5xx" {
  count = var.enable_app_service_5xx_monitor ? 1 : 0

  name = "[${upper(var.environment)}] Azure App Service HTTP 5xx errors"
  type = "metric alert"

  # Confirm the metric name/dimensions in Metrics Explorer before enabling.
  query = "sum(last_5m):sum:azure.app_services.http_5xx{*} by {name} > 10"

  message = <<-EOT
    Azure App Service HTTP 5xx errors exceeded the configured threshold.
    Check application logs, dependencies, deployment history, and App Service health.
    ${local.notify}
  EOT

  monitor_thresholds {
    warning  = 5
    critical = 10
  }

  evaluation_delay    = 300
  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 60
  priority            = 2
  include_tags        = true
  tags                = local.common_tags
}
