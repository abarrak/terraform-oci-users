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
