data "oci_kms_vaults" "compartment_vaults" {
  compartment_id = var.compartment_id
}


data "oci_kms_keys" "compartment_keys" {
  compartment_id      = var.compartment_id
  management_endpoint = data.oci_kms_vaults.compartment_vaults.vaults[0].management_endpoint
}
