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
  source    = "abarrak/oci-users"
  version   = "1.0.0"

  providers = {
    oci    = oci
  }
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
