<!-- BEGIN_TF_DOCS -->
# Terraform OCI Local Users

[![Lints](https://github.com/abarrak/terraform-oci-users/actions/workflows/format.yml/badge.svg)](https://github.com/abarrak/terraform-oci-users/actions/workflows/format.yml) [![Docs](https://github.com/abarrak/terraform-oci-users/actions/workflows/docs.yml/badge.svg)](https://github.com/abarrak/terraform-oci-users/actions/workflows/docs.yml) [![Security](https://github.com/abarrak/terraform-oci-users/actions/workflows/security.yml/badge.svg)](https://github.com/abarrak/terraform-oci-users/actions/workflows/security.yml)

This module provides ability to create and manage users and service accounts with groups and polices in oracle cloud (OCI).

## Features

Provison and manage the following resources in OCI:
1. Users.
2. Groups.
3. Policies.
4. API Keys.
5. Customer Secret Keys (for S3).
6. Persistence of authentication secrets in `Vault` secrets.

## Dependency

Vault is required when provisiong api keys and tokens.<br>
The main one in compartment is queried daynamically in `data.tf` and used.

## Usage

```hcl
module "local-users" {
  source  = "abarrak/users/oci"
  version = "1.0.0"

  tenancy_id     = var.tenancy_id
  compartment_id = var.compartment_id

  local_users = [
    {
      username    = "my-sa",
      group       = "my-sa-group",
      description = "A service account for some bucket integrations service account."
      policy      = [
        "Allow group my-sa-group to read buckets in compartment A",
        "Allow group my-sa-group to use buckets in compartment B"
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
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 6.21.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.6 |

## Resources

| Name | Type |
|------|------|
| [oci_kms_keys.compartment_keys](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/kms_keys) | data source |
| [oci_kms_vaults.compartment_vaults](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/kms_vaults) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capabilities"></a> [capabilities](#input\_capabilities) | (Optional) The capabilities allowed and provisioned for local users or service accounts. | <pre>object({ api_keys = string, auth_tokens = string, smtp_credentials = string,<br/>                         console_password = string, customer_secret_keys = string })</pre> | <pre>{<br/>  "api_keys": "true",<br/>  "auth_tokens": "false",<br/>  "console_password": "false",<br/>  "customer_secret_keys": "true",<br/>  "smtp_credentials": "false"<br/>}</pre> | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of compartment to provison resources in (except tenancy-level resources). | `string` | n/a | yes |
| <a name="input_local_users"></a> [local\_users](#input\_local\_users) | A list of local users or service accounts to provision including group name and policy statements list. | `list(object({ username = string, group = string, description = string, policy = list(string) }))` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) tags to attach to the provisioned resources. | `map(any)` | n/a | yes |
| <a name="input_tenancy_id"></a> [tenancy\_id](#input\_tenancy\_id) | The OCID of tenancy. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_local_group_ids"></a> [local\_group\_ids](#output\_local\_group\_ids) | The ocid value for the local svc-account user groups. |
| <a name="output_local_policies_ids"></a> [local\_policies\_ids](#output\_local\_policies\_ids) | The ocid value for the local svc-account user policies. |
| <a name="output_local_user_statuses"></a> [local\_user\_statuses](#output\_local\_user\_statuses) | The status for the local svc-account users. |
| <a name="output_local_users_api_key_fingerprints"></a> [local\_users\_api\_key\_fingerprints](#output\_local\_users\_api\_key\_fingerprints) | The key's fingerprint (e.g., 12:34:56:78:90:ab:cd:ef:12:34:56:78:90:ab:cd:ef). |
| <a name="output_local_users_api_key_ids"></a> [local\_users\_api\_key\_ids](#output\_local\_users\_api\_key\_ids) | An Oracle-assigned identifier for the key, in this format: TENANCY\_OCID/USER\_OCID/KEY\_FINGERPRINT. |
| <a name="output_local_users_ids"></a> [local\_users\_ids](#output\_local\_users\_ids) | The ocid values for the local svc-account users. |

# License

MIT.
<!-- END_TF_DOCS -->
