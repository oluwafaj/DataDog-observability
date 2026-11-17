# Connect Datadog to the Azure tenant/subscription.
# The Entra application must have at least Monitoring Reader on each
# subscription you want Datadog to monitor.
resource "datadog_integration_azure" "faj_azure" {
  tenant_name   = var.azure_tenant_id
  client_id     = var.azure_client_id
  client_secret = var.azure_client_secret

  metrics_enabled             = true
  resource_collection_enabled = true
  cspm_enabled                = false

  # Leave filters empty initially so all supported Azure resources are discovered.
  host_filters             = ""
  app_service_plan_filters = ""
  container_app_filters    = ""

  automute = true
}
