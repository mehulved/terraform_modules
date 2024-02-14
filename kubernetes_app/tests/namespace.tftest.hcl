variables {
  app_name = "test-app"
  domain = "one2.local"
  environment = "prod"
  namespace = "test"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

run "same_namespace_for_all_resources" {
  command = plan

  assert {
    condition = alltrue([
      (kubernetes_persistent_volume_claim_v1.app_data_claim.metadata[0].namespace == (var.namespace)),
      (kubernetes_pod_v1.app.metadata[0].namespace == (var.namespace)),
      (kubernetes_service_v1.app_service.metadata[0].namespace == (var.namespace)),
      (kubernetes_ingress_v1.app_ingress.metadata[0].namespace == (var.namespace)),
    ])
    error_message = "All resources should be in the same namespace."
  }
}