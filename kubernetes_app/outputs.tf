output "app_storage_path" {
  description = "Storage path for the app"
  value       = kubernetes_persistent_volume_v1.app_data.spec[0].persistent_volume_source[0].host_path[0].path
}

output "app_path" {
  description = "HTTP Path for the app"
  value       = kubernetes_ingress_v1.app_ingress.spec[0].rule[0].http[0].path[0].path
}

output "app_environment" {
  description = "Environment mode for the app"
  value       = kubernetes_pod_v1.app.metadata[0].labels.environment
}