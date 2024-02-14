# kubernetes_app

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.25.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.25.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_ingress_v1.app_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.25.2/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace_v1.app_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.25.2/docs/resources/namespace_v1) | resource |
| [kubernetes_persistent_volume_claim_v1.app_data_claim](https://registry.terraform.io/providers/hashicorp/kubernetes/2.25.2/docs/resources/persistent_volume_claim_v1) | resource |
| [kubernetes_persistent_volume_v1.app_data](https://registry.terraform.io/providers/hashicorp/kubernetes/2.25.2/docs/resources/persistent_volume_v1) | resource |
| [kubernetes_pod_v1.app](https://registry.terraform.io/providers/hashicorp/kubernetes/2.25.2/docs/resources/pod_v1) | resource |
| [kubernetes_service_v1.app_service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.25.2/docs/resources/service_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_container_image"></a> [app\_container\_image](#input\_app\_container\_image) | Application container image | `string` | `"nginx:latest"` | no |
| <a name="input_app_health_check_path"></a> [app\_health\_check\_path](#input\_app\_health\_check\_path) | Application Health Check Path | `string` | `"/"` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the app | `string` | n/a | yes |
| <a name="input_app_port"></a> [app\_port](#input\_app\_port) | Application Port | `number` | `80` | no |
| <a name="input_app_resources"></a> [app\_resources](#input\_app\_resources) | Resource limits and requests for the app | <pre>list(object({<br>    limits = optional(object({<br>      cpu    = optional(string)<br>      memory = optional(string)<br>    }))<br>    requests = optional(object({<br>      cpu    = optional(string)<br>      memory = optional(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain for the app | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Name | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace in which to deploy the app | `string` | n/a | yes |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | Application Port | `number` | `80` | no |
| <a name="input_storage_capacity"></a> [storage\_capacity](#input\_storage\_capacity) | Storage Capacity for PV claim | `string` | `"10Gi"` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Class for storage volume | `string` | `"standard"` | no |
| <a name="input_storage_path"></a> [storage\_path](#input\_storage\_path) | Path for the data storage volume | `string` | `"/data"` | no |
| <a name="input_storage_requests"></a> [storage\_requests](#input\_storage\_requests) | Requested storage for PV claim | `string` | `"5Gi"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_environment"></a> [app\_environment](#output\_app\_environment) | Environment mode for the app |
| <a name="output_app_path"></a> [app\_path](#output\_app\_path) | HTTP Path for the app |
| <a name="output_app_storage_path"></a> [app\_storage\_path](#output\_app\_storage\_path) | Storage path for the app |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
