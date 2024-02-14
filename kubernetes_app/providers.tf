terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.25.2"
    }
  }

  required_version = "~> 1.7.0"
}

provider "kubernetes" {}