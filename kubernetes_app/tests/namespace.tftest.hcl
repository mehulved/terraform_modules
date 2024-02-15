variables {
  app_name = "test-app"
  domain = "one2.local"
  environment = "prod"
  namespace = "test"
  cluster_host = compact([ for cluster in lookup(yamldecode(file("~/.kube/config")), "clusters"): (cluster.name == "minikube" ? cluster.cluster.server: null) ])[0]
  client_certificate = "${file("~/.minikube/profiles/minikube/client.crt")}"
  client_key = "${file("~/.minikube/profiles/minikube/client.key")}"
  cluster_ca_certificate = "${file("~/.minikube/ca.crt")}"
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