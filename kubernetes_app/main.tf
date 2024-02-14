##############################
# Namespace
##############################

resource "kubernetes_namespace_v1" "app_namespace" {
  metadata {
    name = var.namespace
    labels = {
      environment = var.environment
    }
  }
}

##############################
# Storage
##############################

resource "kubernetes_persistent_volume_v1" "app_data" {
  metadata {
    name = "${var.app_name}-storage"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    capacity = {
      storage = var.storage_capacity
    }
    storage_class_name = var.storage_class
    persistent_volume_source {
      host_path {
        path = var.storage_path
        type = "DirectoryOrCreate"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "app_data_claim" {
  metadata {
    name      = "${var.app_name}-storage-claim"
    namespace = kubernetes_namespace_v1.app_namespace.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage_requests
      }
    }

    volume_name = kubernetes_persistent_volume_v1.app_data.metadata[0].name
  }

}

##############################
# App
##############################

resource "kubernetes_pod_v1" "app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.app_namespace.metadata[0].name

    labels = {
      environment              = var.environment
      "app.kubernetes.io/name" = var.app_name
    }
  }

  spec {
    container {
      name  = var.app_name
      image = var.app_container_image

      dynamic "resources" {
        for_each = var.app_resources[*]
        content {
          limits = resources.value.limits != null ? {
            cpu    = resources.value.limits.cpu != null ? resources.value.limits.cpu : ""
            memory = resources.value.limits.memory != null ? resources.value.limits.memory : ""
          } : {}
          requests = resources.value.requests != null ? {
            cpu    = resources.value.requests.cpu != null ? resources.value.requests.cpu : ""
            memory = resources.value.requests.memory != null ? resources.value.requests.memory : ""
          } : {}
        }
      }

      liveness_probe {
        http_get {
          path = var.app_health_check_path
          port = var.app_port
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "app_service" {
  metadata {
    name      = "${var.app_name}-service"
    namespace = kubernetes_namespace_v1.app_namespace.metadata[0].name
  }

  spec {
    selector = {
      "app.kubernetes.io/name" = var.app_name
    }

    port {
      port        = var.app_port
      target_port = var.service_port
    }

    type = "NodePort"
  }
}

##############################
# Networking
##############################

resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name      = "${var.app_name}-ingress"
    namespace = kubernetes_namespace_v1.app_namespace.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
    }
  }

  spec {
    rule {
      host = "${var.environment}.${var.domain}"
      http {
        path {
          backend {
            service {
              name = kubernetes_service_v1.app_service.metadata[0].name
              port {
                number = kubernetes_service_v1.app_service.spec[0].port[0].target_port
              }
            }
          }
        }
      }
    }
  }
}