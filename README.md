# Terraform OCI Local Users

[![Lints](https://github.com/abarrak/terraform-oci-users/actions/workflows/format.yml/badge.svg)](https://github.com/abarrak/terraform-oci-users/actions/workflows/format.yml) [![Docs](https://github.com/abarrak/terraform-oci-users/actions/workflows/docs.yml/badge.svg)](https://github.com/abarrak/terraform-oci-users/actions/workflows/docs.yml) [![Security](https://github.com/abarrak/terraform-oci-users/actions/workflows/security.yml/badge.svg)](https://github.com/abarrak/terraform-oci-users/actions/workflows/security.yml)

This module provides ability to create and manage users with groups and polices in oracle cloud (OCI).

## Features

Provison and manage the following resources in OCI:
1. Users.
2. Groups.
3. Policies.
4. API Keys.
5. Customer Secret Keys (for S3).
6. Persistence of authentication secrets in `Vault` secrets.

## Usage

```hcl
module "local-users" {
  source  = "abarrak/users/oci"
  version = "1.0.0"

  tenancy_id     = var.tenancy_id
  compartment_id = var.compartment_id

  local_svc_account_users = [
    {
      username    = "rclone-sa",
      group       = "rclone-sa-group",
      description = "A service account for rclone."
      policy      = [
        "Allow group rclone-group to read buckets in compartment A",
        "Allow group rclone-group to use buckets in compartment A"
      ]
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 5.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 6.21.0 |

## Resources

| Name | Type |
|------|------|
| [oci_kms_keys.compartment_keys](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/kms_keys) | data source |
| [oci_kms_vaults.compartment_vaults](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/kms_vaults) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of compartment to provison resources in (except tenancy-level resources). | `string` | n/a | yes |
| <a name="input_local_svc_account_users"></a> [local\_svc\_account\_users](#input\_local\_svc\_account\_users) | A list of local users or service accounts to provision including group name and policy statements list. | `list(object({ username = string, group = string, description = string, policy = list(string) }))` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) tags to attach to the provisioned resources. | `map(any)` | n/a | yes |
| <a name="input_tenancy_id"></a> [tenancy\_id](#input\_tenancy\_id) | The OCID of tenancy. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_local_group_ids"></a> [local\_group\_ids](#output\_local\_group\_ids) | The ocid value for the local svc-account user groups. |
| <a name="output_local_policies_ids"></a> [local\_policies\_ids](#output\_local\_policies\_ids) | The ocid value for the local svc-account user policies. |
| <a name="output_local_user_statuses"></a> [local\_user\_statuses](#output\_local\_user\_statuses) | The status for the local svc-account users. |
| <a name="output_local_users_ids"></a> [local\_users\_ids](#output\_local\_users\_ids) | The ocid values for the local svc-account users. |

# License

MIT.
<!-- END_TF_DOCS -->
