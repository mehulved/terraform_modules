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

run "no_resources_set" {
  command = plan

  assert {
    condition = (contains(keys(kubernetes_pod_v1.app.spec[0].container[0]), "resources"))
    error_message ="There should be no resources set by default."
  }
}

run "set_resources" {
  variables {
    app_resources = {
      limits = {
        cpu = "1"
        memory = "2Gi"
      }
      requests = {
        cpu = "250m"
        memory = "250Mi"
      }
    }
  }
  command = apply

  assert {
    condition = (length(kubernetes_pod_v1.app.spec[0].container[0].resources) == 1)
    error_message = "There should limits set in this block."
  }

  assert {
    condition = length(kubernetes_pod_v1.app.spec[0].container[0].resources[0].limits) == length(var.app_resources.limits)
    error_message = "Set limits don't match the plan."
  }

  assert {
    condition = length(kubernetes_pod_v1.app.spec[0].container[0].resources[0].requests) == length(var.app_resources.requests)
    error_message = "Set requests don't match the plan."
  }
}

run "set_limits" {
  variables {
    app_resources = {
      limits = {
        cpu = "1"
        memory = "2Gi"
      }
    }
  }
  command = apply

  assert {
    condition = (length(kubernetes_pod_v1.app.spec[0].container[0].resources) == 1)
    error_message = "There should limits set in this block."
  }

  assert {
    condition = kubernetes_pod_v1.app.spec[0].container[0].resources[0].limits.cpu == var.app_resources.limits.cpu
    error_message = "Set value for limits cpu doesn't match the plan."
  }

  assert {
    condition = kubernetes_pod_v1.app.spec[0].container[0].resources[0].limits.memory == var.app_resources.limits.memory
    error_message = "Set value for requests memory doesn't match the plan."
  }

  assert {
    condition = (contains(keys(kubernetes_pod_v1.app.spec[0].container[0].resources[0]), "requests"))
    error_message = "There should be no requests."
  }
}

run "set_requests" {
  variables {
    app_resources = {
      requests = {
        cpu = "250m"
        memory = "250Mi"
      }
    }
  }
  command = apply

  assert {
    condition = (length(kubernetes_pod_v1.app.spec[0].container[0].resources) == 1)
    error_message = "There should limits set in this block."
  }

  assert {
    condition = kubernetes_pod_v1.app.spec[0].container[0].resources[0].requests.cpu == var.app_resources.requests.cpu
    error_message = "Set value for requests cpu doesn't match the plan."
  }

  assert {
    condition = kubernetes_pod_v1.app.spec[0].container[0].resources[0].requests.memory == var.app_resources.requests.memory
    error_message = "Set value for requests memory doesn't match the plan."
  }

  assert {
    condition = (contains(keys(kubernetes_pod_v1.app.spec[0].container[0].resources[0]), "limits"))
    error_message = "There should be no limits."
  }
}