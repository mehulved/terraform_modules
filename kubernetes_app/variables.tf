variable "environment" {
  description = "Environment Name"
  type        = string

  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "Valid Environments - dev, stg, prod"
  }
}

variable "namespace" {
  description = "Namespace in which to deploy the app"
  type        = string
}

variable "domain" {
  description = "Domain for the app"
  type        = string
}

variable "storage_class" {
  description = "Class for storage volume"
  type        = string
  default     = "standard"
}

variable "storage_requests" {
  description = "Requested storage for PV claim"
  type        = string
  default     = "5Gi"
}

variable "storage_capacity" {
  description = "Storage Capacity for PV claim"
  type        = string
  default     = "10Gi"
}

variable "storage_path" {
  description = "Path for the data storage volume"
  type        = string
  default     = "/data"
}

variable "app_name" {
  description = "Name of the app"
  type        = string
}

variable "app_container_image" {
  description = "Application container image"
  type        = string
  default     = "nginx:latest"
}

variable "app_health_check_path" {
  description = "Application Health Check Path"
  type        = string
  default     = "/"
}

variable "app_port" {
  description = "Application Port"
  type        = number
  default     = 80

  validation {
    condition     = (var.app_port <= 65535 && var.app_port >= 1)
    error_message = "App port should be between 1and 65535"
  }
}

variable "app_resources" {
  description = "Resource limits and requests for the app"
  type = list(object({
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  }))

  default = []
}

variable "service_port" {
  description = "Application Port"
  type        = number
  default     = 80

  validation {
    condition     = (var.service_port <= 65535 && var.service_port >= 1)
    error_message = "Service port should be between 1and 65535"
  }
}