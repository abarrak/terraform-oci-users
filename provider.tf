provider "oci" {
  tenancy_ocid = var.tenancy_id
}

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">= 5.9.0"
    }
  }
  required_version = "~> 1.3"
}
